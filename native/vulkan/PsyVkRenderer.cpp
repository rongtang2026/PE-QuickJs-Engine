#include "PsyVkRenderer.h"
#include "PsyVkCommands.h"
#include <android/log.h>
#include <android/native_window_jni.h>
#include <cstring>
#include <cstdio>
#include <cmath>
#include <fstream>
#include <sstream>

void* g_psyvulkan = nullptr;
#define PSYVK_DEFINE(name) PFN_##name psy_##name = nullptr;
PSYVK_CMD_LIST(PSYVK_DEFINE)

PsyVkState g_psyvk;

#define LOGI(...) __android_log_print(ANDROID_LOG_INFO,  PSYVK_TAG, __VA_ARGS__)
#define LOGW(...) __android_log_print(ANDROID_LOG_WARN,  PSYVK_TAG, __VA_ARGS__)
#define VKC(expr) do { VkResult _r = (expr); if (_r != VK_SUCCESS) { \
    std::ostringstream _o; _o << #expr << " failed: " << _r; return _o.str(); } } while(0)

static uint32_t pickMemoryType(uint32_t bits, VkMemoryPropertyFlags flags)
{
    VkPhysicalDeviceMemoryProperties mp{};
    psy_vkGetPhysicalDeviceMemoryProperties(g_psyvk.physical, &mp);
    for (uint32_t i = 0; i < mp.memoryTypeCount; ++i)
        if ((bits & (1u << i)) && (mp.memoryTypes[i].propertyFlags & flags) == flags) return i;
    return 0;
}

static std::string readSpirv(const char* path, std::vector<uint32_t>& out)
{
    std::ifstream f(path, std::ios::binary | std::ios::ate);
    if (!f) return std::string("missing shader: ") + path;
    std::streamsize n = f.tellg();
    f.seekg(0);
    out.resize((size_t(n) + 3) / 4);
    f.read(reinterpret_cast<char*>(out.data()), n);
    return "";
}

static std::string createInstance()
{
    VkApplicationInfo app{};
    app.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
    app.pApplicationName = "PE-QuickJs-Engine Vulkan";
    app.applicationVersion = VK_MAKE_VERSION(1, 1, 0);
    app.pEngineName = "PsyVK";
    app.apiVersion = VK_API_VERSION_1_0;

    const char* layers[] = { "VK_LAYER_KHRONOS_validation" };
    const char* exts[] = { VK_KHR_SURFACE_EXTENSION_NAME, VK_KHR_ANDROID_SURFACE_EXTENSION_NAME };
    VkInstanceCreateInfo ci{};
    ci.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
    ci.pApplicationInfo = &app;
    ci.enabledExtensionCount = 2;
    ci.ppEnabledExtensionNames = exts;
#ifndef NDEBUG
    ci.enabledLayerCount = 1;
    ci.ppEnabledLayerNames = layers;
#endif
    VKC(psy_vkCreateInstance(&ci, nullptr, &g_psyvk.instance));
    return "";
}

static std::string pickPhysicalDevice()
{
    uint32_t count = 1;
    VkPhysicalDevice devs[8]{};
    VkResult r = psy_vkEnumeratePhysicalDevices(g_psyvk.instance, &count, devs);
    if (r != VK_SUCCESS || count == 0) return "no Vulkan physical device";
    g_psyvk.physical = devs[0];
    psy_vkGetPhysicalDeviceProperties(g_psyvk.physical, &g_psyvk.props);

    uint32_t qCount = 0;
    psy_vkGetPhysicalDeviceQueueFamilyProperties(g_psyvk.physical, &qCount, nullptr);
    std::vector<VkQueueFamilyProperties> q(qCount);
    psy_vkGetPhysicalDeviceQueueFamilyProperties(g_psyvk.physical, &qCount, q.data());
    for (uint32_t i = 0; i < qCount; ++i)
    {
        VkBool32 present = VK_FALSE;
        psy_vkGetPhysicalDeviceSurfaceSupportKHR(g_psyvk.physical, i, g_psyvk.surface, &present);
        if ((q[i].queueFlags & VK_QUEUE_GRAPHICS_BIT) && present) { g_psyvk.queueFamily = i; break; }
    }
    return "";
}

static std::string createSurface(ANativeWindow* window)
{
    if (!window) return "ANativeWindow_fromSurface returned null";
    VkAndroidSurfaceCreateInfoKHR si{};
    si.sType = VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR;
    si.window = window;
    VKC(psy_vkCreateAndroidSurfaceKHR(g_psyvk.instance, &si, nullptr, &g_psyvk.surface));
    return "";
}

static std::string createDevice()
{
    float priority = 1.0f;
    VkDeviceQueueCreateInfo qi{};
    qi.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
    qi.queueFamilyIndex = g_psyvk.queueFamily;
    qi.queueCount = 1;
    qi.pQueuePriorities = &priority;
    const char* exts[] = { VK_KHR_SWAPCHAIN_EXTENSION_NAME };
    VkDeviceCreateInfo di{};
    di.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
    di.queueCreateInfoCount = 1;
    di.pQueueCreateInfos = &qi;
    di.enabledExtensionCount = 1;
    di.ppEnabledExtensionNames = exts;
    VKC(psy_vkCreateDevice(g_psyvk.physical, &di, nullptr, &g_psyvk.device));
    psy_vkGetDeviceQueue(g_psyvk.device, g_psyvk.queueFamily, 0, &g_psyvk.queue);
    return "";
}

static std::string createSwapchain()
{
    VkSurfaceCapabilitiesKHR caps{};
    psy_vkGetPhysicalDeviceSurfaceCapabilitiesKHR(g_psyvk.physical, g_psyvk.surface, &caps);
    uint32_t formatCount = 0;
    psy_vkGetPhysicalDeviceSurfaceFormatsKHR(g_psyvk.physical, g_psyvk.surface, &formatCount, nullptr);
    std::vector<VkSurfaceFormatKHR> formats(formatCount);
    psy_vkGetPhysicalDeviceSurfaceFormatsKHR(g_psyvk.physical, g_psyvk.surface, &formatCount, formats.data());
    if (formatCount > 0) g_psyvk.swapFormat = formats[0].format;
    g_psyvk.extent = caps.currentExtent;
    if (g_psyvk.extent.width == 0) { g_psyvk.extent = { g_psyvk.width, g_psyvk.height }; }

    VkSwapchainCreateInfoKHR si{};
    si.sType = VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
    si.surface = g_psyvk.surface;
    si.minImageCount = caps.minImageCount + 1;
    si.imageFormat = g_psyvk.swapFormat;
    si.imageColorSpace = VK_COLORSPACE_SRGB_NONLINEAR_KHR;
    si.imageExtent = g_psyvk.extent;
    si.imageArrayLayers = 1;
    si.imageUsage = VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
    si.imageSharingMode = VK_SHARING_MODE_EXCLUSIVE;
    si.preTransform = caps.currentTransform;
    si.compositeAlpha = VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR;
    si.presentMode = VK_PRESENT_MODE_FIFO_KHR;
    si.clipped = VK_TRUE;
    VKC(psy_vkCreateSwapchainKHR(g_psyvk.device, &si, nullptr, &g_psyvk.swapchain));

    uint32_t imageCount = 0;
    psy_vkGetSwapchainImagesKHR(g_psyvk.device, g_psyvk.swapchain, &imageCount, nullptr);
    g_psyvk.swapImages.resize(imageCount);
    psy_vkGetSwapchainImagesKHR(g_psyvk.device, g_psyvk.swapchain, &imageCount, g_psyvk.swapImages.data());
    g_psyvk.swapViews.resize(imageCount);
    for (uint32_t i = 0; i < imageCount; ++i)
    {
        VkImageViewCreateInfo vi{};
        vi.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
        vi.image = g_psyvk.swapImages[i];
        vi.viewType = VK_IMAGE_VIEW_TYPE_2D;
        vi.format = g_psyvk.swapFormat;
        vi.components = { VK_COMPONENT_SWIZZLE_IDENTITY, VK_COMPONENT_SWIZZLE_IDENTITY,
                          VK_COMPONENT_SWIZZLE_IDENTITY, VK_COMPONENT_SWIZZLE_IDENTITY };
        vi.subresourceRange = { VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };
        VKC(psy_vkCreateImageView(g_psyvk.device, &vi, nullptr, &g_psyvk.swapViews[i]));
    }
    return "";
}

static std::string createRenderPass()
{
    VkAttachmentDescription color{};
    color.format = g_psyvk.swapFormat;
    color.samples = VK_SAMPLE_COUNT_1_BIT;
    color.loadOp = VK_ATTACHMENT_LOAD_OP_CLEAR;
    color.storeOp = VK_ATTACHMENT_STORE_OP_STORE;
    color.stencilLoadOp = VK_ATTACHMENT_LOAD_OP_DONT_CARE;
    color.stencilStoreOp = VK_ATTACHMENT_STORE_OP_DONT_CARE;
    color.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    color.finalLayout = VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
    VkAttachmentReference ref{ 0, VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL };
    VkSubpassDescription sub{};
    sub.pipelineBindPoint = VK_PIPELINE_BIND_POINT_GRAPHICS;
    sub.colorAttachmentCount = 1;
    sub.pColorAttachments = &ref;
    VkRenderPassCreateInfo ri{};
    ri.sType = VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
    ri.attachmentCount = 1;
    ri.pAttachments = &color;
    ri.subpassCount = 1;
    ri.pSubpasses = &sub;
    VKC(psy_vkCreateRenderPass(g_psyvk.device, &ri, nullptr, &g_psyvk.renderPass));
    return "";
}

static std::string createSamplerAndLayout()
{
    VkSamplerCreateInfo si{};
    si.sType = VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
    si.magFilter = VK_FILTER_LINEAR;
    si.minFilter = VK_FILTER_LINEAR;
    si.addressModeU = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
    si.addressModeV = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
    si.addressModeW = VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
    VKC(psy_vkCreateSampler(g_psyvk.device, &si, nullptr, &g_psyvk.sampler));

    VkDescriptorSetLayoutBinding binding{};
    binding.binding = 0;
    binding.descriptorType = VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
    binding.descriptorCount = 1;
    binding.stageFlags = VK_SHADER_STAGE_FRAGMENT_BIT;
    binding.pImmutableSamplers = &g_psyvk.sampler;
    VkDescriptorSetLayoutCreateInfo li{};
    li.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
    li.bindingCount = 1;
    li.pBindings = &binding;
    VKC(psy_vkCreateDescriptorSetLayout(g_psyvk.device, &li, nullptr, &g_psyvk.setLayout));
    return "";
}

static std::string createPipeline()
{
    std::vector<uint32_t> vert, frag;
    std::string e = readSpirv("/sdcard/Android/data/DingLing.pe.QuickJs.Engine/files/psyvk_quad.vert.spv", vert);
    if (!e.empty()) return e;
    e = readSpirv("/sdcard/Android/data/DingLing.pe.QuickJs.Engine/files/psyvk_quad.frag.spv", frag);
    if (!e.empty()) return e;

    auto makeModule = [](const std::vector<uint32_t>& code, VkShaderModule& out) -> VkResult
    {
        VkShaderModuleCreateInfo mi{};
        mi.sType = VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
        mi.codeSize = code.size() * 4;
        mi.pCode = code.data();
        return psy_vkCreateShaderModule(g_psyvk.device, &mi, nullptr, &out);
    };
    VkShaderModule vs = VK_NULL_HANDLE, fs = VK_NULL_HANDLE;
    VKC(makeModule(vert, vs)); VKC(makeModule(frag, fs));

    VkPipelineShaderStageCreateInfo stages[2]{};
    stages[0] = { VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO, nullptr, 0,
                  VK_SHADER_STAGE_VERTEX_BIT, vs, "main", nullptr };
    stages[1] = { VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO, nullptr, 0,
                  VK_SHADER_STAGE_FRAGMENT_BIT, fs, "main", nullptr };

    VkVertexInputBindingDescription bind{ 0, sizeof(PsyVkVertex), VK_VERTEX_INPUT_RATE_VERTEX };
    VkVertexInputAttributeDescription attrs[4]{};
    attrs[0] = { 0, 0, VK_FORMAT_R32G32_SFLOAT, offsetof(PsyVkVertex, x) };
    attrs[1] = { 1, 0, VK_FORMAT_R32G32_SFLOAT, offsetof(PsyVkVertex, u) };
    attrs[2] = { 2, 0, VK_FORMAT_R32G32B32A32_SFLOAT, offsetof(PsyVkVertex, r) };
    attrs[3] = { 3, 0, VK_FORMAT_R32_SFLOAT, offsetof(PsyVkVertex, slot) };
    VkPipelineVertexInputStateCreateInfo vi{};
    vi.sType = VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
    vi.vertexBindingDescriptionCount = 1; vi.pVertexBindingDescriptions = &bind;
    vi.vertexAttributeDescriptionCount = 4; vi.pVertexAttributeDescriptions = attrs;

    VkPipelineInputAssemblyStateCreateInfo ia{};
    ia.sType = VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
    ia.topology = VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
    VkViewport vp{ 0, 0, (float)g_psyvk.extent.width, (float)g_psyvk.extent.height, 0, 1 };
    VkRect2D sc{ { 0, 0 }, g_psyvk.extent };
    VkPipelineViewportStateCreateInfo vps{};
    vps.sType = VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
    vps.viewportCount = 1; vps.pViewports = &vp;
    vps.scissorCount = 1; vps.pScissors = &sc;
    VkPipelineRasterizationStateCreateInfo rs{};
    rs.sType = VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
    rs.polygonMode = VK_POLYGON_MODE_FILL;
    rs.cullMode = VK_CULL_MODE_NONE;
    rs.frontFace = VK_FRONT_FACE_CLOCKWISE;
    rs.lineWidth = 1.0f;
    VkPipelineMultisampleStateCreateInfo ms{};
    ms.sType = VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
    ms.rasterizationSamples = VK_SAMPLE_COUNT_1_BIT;
    VkPipelineColorBlendAttachmentState blend{};
    blend.blendEnable = VK_TRUE;
    blend.srcColorBlendFactor = VK_BLEND_FACTOR_SRC_ALPHA;
    blend.dstColorBlendFactor = VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA;
    blend.colorBlendOp = VK_BLEND_OP_ADD;
    blend.srcAlphaBlendFactor = VK_BLEND_FACTOR_ONE;
    blend.dstAlphaBlendFactor = VK_BLEND_FACTOR_ZERO;
    blend.alphaBlendOp = VK_BLEND_OP_ADD;
    blend.colorWriteMask = VK_COLOR_COMPONENT_R_BIT | VK_COLOR_COMPONENT_G_BIT |
                           VK_COLOR_COMPONENT_B_BIT | VK_COLOR_COMPONENT_A_BIT;
    VkPipelineColorBlendStateCreateInfo cb{};
    cb.sType = VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
    cb.attachmentCount = 1; cb.pAttachments = &blend;

    VkPipelineLayoutCreateInfo pl{};
    pl.sType = VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
    pl.setLayoutCount = 1; pl.pSetLayouts = &g_psyvk.setLayout;
    VKC(psy_vkCreatePipelineLayout(g_psyvk.device, &pl, nullptr, &g_psyvk.pipelineLayout));

    VkGraphicsPipelineCreateInfo pi{};
    pi.sType = VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
    pi.stageCount = 2; pi.pStages = stages;
    pi.pVertexInputState = &vi; pi.pInputAssemblyState = &ia;
    pi.pViewportState = &vps; pi.pRasterizationState = &rs;
    pi.pMultisampleState = &ms; pi.pColorBlendState = &cb;
    pi.layout = g_psyvk.pipelineLayout;
    pi.renderPass = g_psyvk.renderPass;
    pi.subpass = 0;
    VKC(psy_vkCreateGraphicsPipelines(g_psyvk.device, VK_NULL_HANDLE, 1, &pi, nullptr, &g_psyvk.pipeline));
    // device is destroyed.
    return "";
}

static std::string createFramebuffers()
{
    g_psyvk.framebuffers.resize(g_psyvk.swapViews.size());
    for (size_t i = 0; i < g_psyvk.swapViews.size(); ++i)
    {
        VkFramebufferCreateInfo fi{};
        fi.sType = VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
        fi.renderPass = g_psyvk.renderPass;
        fi.attachmentCount = 1;
        fi.pAttachments = &g_psyvk.swapViews[i];
        fi.width = g_psyvk.extent.width;
        fi.height = g_psyvk.extent.height;
        fi.layers = 1;
        VKC(psy_vkCreateFramebuffer(g_psyvk.device, &fi, nullptr, &g_psyvk.framebuffers[i]));
    }
    return "";
}

static std::string createCommandsAndSync()
{
    VkCommandPoolCreateInfo cp{};
    cp.sType = VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
    cp.queueFamilyIndex = g_psyvk.queueFamily;
    cp.flags = VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
    VKC(psy_vkCreateCommandPool(g_psyvk.device, &cp, nullptr, &g_psyvk.commandPool));
    VkCommandBufferAllocateInfo ai{};
    ai.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    ai.commandPool = g_psyvk.commandPool;
    ai.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    ai.commandBufferCount = 1;
    VKC(psy_vkAllocateCommandBuffers(g_psyvk.device, &ai, &g_psyvk.commandBuffer));

    VkSemaphoreCreateInfo si{};
    si.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
    VKC(psy_vkCreateSemaphore(g_psyvk.device, &si, nullptr, &g_psyvk.imageReady));
    VKC(psy_vkCreateSemaphore(g_psyvk.device, &si, nullptr, &g_psyvk.renderDone));

    VkBufferCreateInfo bi{};
    bi.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
    bi.size = sizeof(PsyVkVertex) * 6 * PSYVK_MAX_QUADS;
    bi.usage = VK_BUFFER_USAGE_VERTEX_BUFFER_BIT;
    bi.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
    VKC(psy_vkCreateBuffer(g_psyvk.device, &bi, nullptr, &g_psyvk.vertexBuffer));
    VkMemoryRequirements mr{};
    psy_vkGetBufferMemoryRequirements(g_psyvk.device, g_psyvk.vertexBuffer, &mr);
    VkMemoryAllocateInfo mi{};
    mi.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
    mi.allocationSize = mr.size;
    mi.memoryTypeIndex = pickMemoryType(mr.memoryTypeBits,
        VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VK_MEMORY_PROPERTY_HOST_COHERENT_BIT);
    VKC(psy_vkAllocateMemory(g_psyvk.device, &mi, nullptr, &g_psyvk.vertexMemory));
    VKC(psy_vkBindBufferMemory(g_psyvk.device, g_psyvk.vertexBuffer, g_psyvk.vertexMemory, 0));
    VKC(psy_vkMapMemory(g_psyvk.device, g_psyvk.vertexMemory, 0,
        sizeof(PsyVkVertex) * 6 * PSYVK_MAX_QUADS, 0, &g_psyvk.vertexMapped));
    return "";
}

static std::string createDescriptorPool()
{
    VkDescriptorPoolSize ps{ VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER, PSYVK_MAX_SLOTS };
    VkDescriptorPoolCreateInfo pi{};
    pi.sType = VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
    pi.maxSets = PSYVK_MAX_SLOTS;
    pi.poolSizeCount = 1;
    pi.pPoolSizes = &ps;
    VKC(psy_vkCreateDescriptorPool(g_psyvk.device, &pi, nullptr, &g_psyvk.descPool));
    return "";
}

std::string psyvk_create(ANativeWindow* window, int width, int height)
{
    if (g_psyvk.created) return "";
    if (!psyvk_load()) return "dlopen(libvulkan.so) failed";
    g_psyvk.window = window;
    g_psyvk.width = width;
    g_psyvk.height = height;
    std::string e;
    e = createInstance();            if (!e.empty()) return e;
    e = createSurface(window);       if (!e.empty()) return e;
    e = pickPhysicalDevice();        if (!e.empty()) return e;
    e = createDevice();              if (!e.empty()) return e;
    e = createSwapchain();           if (!e.empty()) return e;
    e = createRenderPass();          if (!e.empty()) return e;
    e = createSamplerAndLayout();    if (!e.empty()) return e;
    e = createDescriptorPool();      if (!e.empty()) return e;
    e = createPipeline();            if (!e.empty()) return e;
    e = createFramebuffers();        if (!e.empty()) return e;
    e = createCommandsAndSync();     if (!e.empty()) return e;
    g_psyvk.created = true;
    char ready[256];
    snprintf(ready, sizeof(ready), "Vulkan ready: %s, swapchain %ux%u",
             g_psyvk.props.deviceName, g_psyvk.extent.width, g_psyvk.extent.height);
    LOGI("%s", ready);
    g_psyvk.diag = "ready";
    return "";
}

void psyvk_destroy()
{
    if (!g_psyvk.created) return;
    psy_vkDeviceWaitIdle(g_psyvk.device);
    for (int i = 0; i < PSYVK_MAX_SLOTS; ++i)
    {
        auto& s = g_psyvk.slots[i];
        if (s.view) psy_vkDestroyImageView(g_psyvk.device, s.view, nullptr);
        if (s.image) psy_vkDestroyImage(g_psyvk.device, s.image, nullptr);
        if (s.memory) psy_vkFreeMemory(g_psyvk.device, s.memory, nullptr);
    }
    psy_vkFreeCommandBuffers(g_psyvk.device, g_psyvk.commandPool, 1, &g_psyvk.commandBuffer);
    psy_vkDestroyCommandPool(g_psyvk.device, g_psyvk.commandPool, nullptr);
    for (auto v : g_psyvk.swapViews) psy_vkDestroyImageView(g_psyvk.device, v, nullptr);
    psy_vkDestroySwapchainKHR(g_psyvk.device, g_psyvk.swapchain, nullptr);
    psy_vkDestroySurfaceKHR(g_psyvk.instance, g_psyvk.surface, nullptr);
    psy_vkDestroySemaphore(g_psyvk.device, g_psyvk.imageReady, nullptr);
    psy_vkDestroySemaphore(g_psyvk.device, g_psyvk.renderDone, nullptr);
    psy_vkDestroyBuffer(g_psyvk.device, g_psyvk.vertexBuffer, nullptr);
    psy_vkFreeMemory(g_psyvk.device, g_psyvk.vertexMemory, nullptr);
    psy_vkDestroyDevice(g_psyvk.device, nullptr);
    psy_vkDestroyInstance(g_psyvk.instance, nullptr);
    if (g_psyvk.window) ANativeWindow_release(g_psyvk.window);
    g_psyvk = PsyVkState{};
    psyvk_unload();
}

std::string psyvk_info()
{
    if (!g_psyvk.created) return "not created";
    uint32_t major = VK_VERSION_MAJOR(g_psyvk.props.apiVersion);
    uint32_t minor = VK_VERSION_MINOR(g_psyvk.props.apiVersion);
    uint32_t patch = VK_VERSION_PATCH(g_psyvk.props.apiVersion);
    char buf[512];
    snprintf(buf, sizeof(buf), "%s (Vulkan %u.%u.%u), %ux%u, %u frames, %d quads",
             g_psyvk.props.deviceName, major, minor, patch,
             g_psyvk.extent.width, g_psyvk.extent.height,
             g_psyvk.frames, (int)g_psyvk.quads);
    return buf;
}

std::string psyvk_diag() { return g_psyvk.diag.empty() ? g_psyvk.lastError : g_psyvk.diag; }
std::string psyvk_hud_line(int id)
{
    if (id < 0 || id >= PSYVK_HUD_LINES) return "";
    return g_psyvk.hudLines[id];
}

// ---- texture slots --------------------------------------------------------
static bool psyvkSlotAllowed(int slot)
{
    if (slot == 0) return true;
    if (slot >= PSYVK_TEX_REQ_SLOT_MIN && slot <= PSYVK_TEX_REQ_SLOT_MAX) return true;
    if (slot >= PSYVK_HUD_SLOT_BASE && slot < PSYVK_HUD_SLOT_BASE + PSYVK_HUD_LINES) return true;
    if (slot >= PSYVK_TEXT_SLOT_BASE && slot < PSYVK_TEXT_SLOT_BASE + PSYVK_TEXT_CACHE_LINES) return true;
    return false;
}

static std::string uploadSlot(int slot, const int* pixels, int width, int height)
{
    if (slot < 0 || slot >= PSYVK_MAX_SLOTS || !psyvkSlotAllowed(slot))
        return "slot out of range";
    if (!g_psyvk.created) return "not created";
    auto& s = g_psyvk.slots[slot];
    if (s.view) { psy_vkDestroyImageView(g_psyvk.device, s.view, nullptr); s.view = VK_NULL_HANDLE; }
    if (s.image) { psy_vkDestroyImage(g_psyvk.device, s.image, nullptr); s.image = VK_NULL_HANDLE; }
    if (s.memory) { psy_vkFreeMemory(g_psyvk.device, s.memory, nullptr); s.memory = VK_NULL_HANDLE; }

    VkDeviceSize bytes = (VkDeviceSize)width * height * 4;
    VkBuffer staging = VK_NULL_HANDLE;
    VkDeviceMemory stageMem = VK_NULL_HANDLE;
    VkBufferCreateInfo bi{};
    bi.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
    bi.size = bytes; bi.usage = VK_BUFFER_USAGE_TRANSFER_SRC_BIT;
    VKC(psy_vkCreateBuffer(g_psyvk.device, &bi, nullptr, &staging));
    VkMemoryRequirements mr{};
    psy_vkGetBufferMemoryRequirements(g_psyvk.device, staging, &mr);
    VkMemoryAllocateInfo mi{};
    mi.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
    mi.allocationSize = mr.size;
    mi.memoryTypeIndex = pickMemoryType(mr.memoryTypeBits, VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT);
    VKC(psy_vkAllocateMemory(g_psyvk.device, &mi, nullptr, &stageMem));
    VKC(psy_vkBindBufferMemory(g_psyvk.device, staging, stageMem, 0));
    void* mapped = nullptr;
    VKC(psy_vkMapMemory(g_psyvk.device, stageMem, 0, bytes, 0, &mapped));
    memcpy(mapped, pixels, (size_t)bytes);

    VkImageCreateInfo ii{};
    ii.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
    ii.imageType = VK_IMAGE_TYPE_2D;
    ii.format = VK_FORMAT_R8G8B8A8_UNORM;
    ii.extent = { (uint32_t)width, (uint32_t)height, 1 };
    ii.mipLevels = 1; ii.arrayLayers = 1;
    ii.samples = VK_SAMPLE_COUNT_1_BIT;
    ii.tiling = VK_IMAGE_TILING_OPTIMAL;
    ii.usage = VK_IMAGE_USAGE_TRANSFER_DST_BIT | VK_IMAGE_USAGE_SAMPLED_BIT;
    VKC(psy_vkCreateImage(g_psyvk.device, &ii, nullptr, &s.image));
    VkMemoryRequirements imr{};
    psy_vkGetImageMemoryRequirements(g_psyvk.device, s.image, &imr);
    VkMemoryAllocateInfo imi{};
    imi.sType = VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
    imi.allocationSize = imr.size;
    imi.memoryTypeIndex = pickMemoryType(imr.memoryTypeBits, VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT);
    VKC(psy_vkAllocateMemory(g_psyvk.device, &imi, nullptr, &s.memory));
    VKC(psy_vkBindImageMemory(g_psyvk.device, s.image, s.memory, 0));

    VkCommandBufferAllocateInfo ai{ VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO, nullptr,
        g_psyvk.commandPool, VK_COMMAND_BUFFER_LEVEL_PRIMARY, 1 };
    VkCommandBuffer cmd = VK_NULL_HANDLE;
    VKC(psy_vkAllocateCommandBuffers(g_psyvk.device, &ai, &cmd));
    VkCommandBufferBeginInfo cb{ VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO, nullptr,
        VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT, nullptr };
    VKC(psy_vkBeginCommandBuffer(cmd, &cb));
    VkImageMemoryBarrier barrier{};
    barrier.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
    barrier.oldLayout = VK_IMAGE_LAYOUT_UNDEFINED;
    barrier.newLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
    barrier.srcQueueFamilyIndex = barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
    barrier.image = s.image;
    barrier.subresourceRange = { VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };
    barrier.srcAccessMask = 0;
    barrier.dstAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
    psy_vkCmdPipelineBarrier(cmd, VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT, VK_PIPELINE_STAGE_TRANSFER_BIT,
                             0, 0, nullptr, 0, nullptr, 1, &barrier);
    VkClearColorValue cc{ { { 0.0f, 0.0f, 0.0f, 0.0f } } };
    VkImageSubresourceRange clearRange{ VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };
    psy_vkCmdClearColorImage(cmd, s.image, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
                            &cc, 1, &clearRange);
    VkBufferImageCopy copy{};
    copy.bufferOffset = 0;
    copy.bufferRowLength = 0; copy.bufferImageHeight = 0;
    copy.imageSubresource = { VK_IMAGE_ASPECT_COLOR_BIT, 0, 0, 1 };
    copy.imageExtent = { (uint32_t)width, (uint32_t)height, 1 };
    psy_vkCmdCopyBufferToImage(cmd, staging, s.image, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &copy);
    barrier.oldLayout = VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL;
    barrier.newLayout = VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
    barrier.srcAccessMask = VK_ACCESS_TRANSFER_WRITE_BIT;
    barrier.dstAccessMask = VK_ACCESS_SHADER_READ_BIT;
    psy_vkCmdPipelineBarrier(cmd, VK_PIPELINE_STAGE_TRANSFER_BIT, VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT,
                             0, 0, nullptr, 0, nullptr, 1, &barrier);
    VKC(psy_vkEndCommandBuffer(cmd));
    VkSubmitInfo si{ VK_STRUCTURE_TYPE_SUBMIT_INFO, nullptr, 0, nullptr, nullptr, 1, &cmd, 0, nullptr };
    VKC(psy_vkQueueSubmit(g_psyvk.queue, 1, &si, VK_NULL_HANDLE));
    psy_vkDeviceWaitIdle(g_psyvk.device);
    psy_vkFreeCommandBuffers(g_psyvk.device, g_psyvk.commandPool, 1, &cmd);
    psy_vkDestroyBuffer(g_psyvk.device, staging, nullptr);
    psy_vkFreeMemory(g_psyvk.device, stageMem, nullptr);

    VkImageViewCreateInfo vi{};
    vi.sType = VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
    vi.image = s.image; vi.viewType = VK_IMAGE_VIEW_TYPE_2D;
    vi.format = VK_FORMAT_R8G8B8A8_UNORM;
    vi.subresourceRange = { VK_IMAGE_ASPECT_COLOR_BIT, 0, 1, 0, 1 };
    VKC(psy_vkCreateImageView(g_psyvk.device, &vi, nullptr, &s.view));
    s.width = width; s.height = height;

    VkDescriptorSetAllocateInfo dsi{ VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO, nullptr,
        g_psyvk.descPool, 1, &g_psyvk.setLayout };
    VKC(psy_vkAllocateDescriptorSets(g_psyvk.device, &dsi, &s.descriptor));
    VkDescriptorImageInfo di{ g_psyvk.sampler, s.view, VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL };
    VkWriteDescriptorSet w{ VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET, nullptr,
        s.descriptor, 0, 0, 1, VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER, &di, nullptr, nullptr };
    psy_vkUpdateDescriptorSets(g_psyvk.device, 1, &w, 0, nullptr);
    return "";
}

std::string psyvk_set_texture(int slot, const int* pixels, int w, int h) { return uploadSlot(slot, pixels, w, h); }
std::string psyvk_add_texture(int slot, const int* pixels, int w, int h) { return uploadSlot(slot, pixels, w, h); }

void psyvk_set_atlas(const int* pixels, int w, int h, const int* rects, int count)
{
    // rects are 4-int groups (x,y,w,h) for each atlas frame, as parsed by
    // VulkanSurfaceHelper.tryLoadAtlas(); the atlas itself occupies slot 0.
    uploadSlot(0, pixels, w, h);
    LOGI("atlas parsed (atlas=%dx%d, %d rects)", w, h, count);
}

void psyvk_set_text(int id, const int* pixels, int w, int h)
{
    if (id >= 0 && id < PSYVK_HUD_LINES) uploadSlot(PSYVK_TEXT_SLOT_BASE + id, pixels, w, h);
}
void psyvk_clear_text()
{
    for (int i = 0; i < PSYVK_HUD_LINES; ++i) g_psyvk.hudLines[i].clear();
}
void psyvk_set_hud_values(const float* values, int count)
{
    g_psyvk.hudValues.assign(values, values + count);
}

void psyvk_submit_quads(const float* quads, int count)
{
    g_psyvk.pendingQuads.assign(quads, quads + count);
}

void psyvk_pump_quads()
{
    const char* path = "/storage/emulated/0/Android/data/DingLing.pe.QuickJs.Engine/files/vk_quads.bin";
    std::ifstream f(path, std::ios::binary | std::ios::ate);
    if (!f) return;
    std::streamsize n = f.tellg();
    f.seekg(0);
    std::vector<float> buf((size_t)n / sizeof(float));
    f.read(reinterpret_cast<char*>(buf.data()), n);
    if (!buf.empty() && g_psyvk.pendingQuads.empty()) g_psyvk.pendingQuads.swap(buf);
}

void psyvk_push_text_quad(float x, float y, float w, float h, int slot)
{
    auto push = [&](float px, float py, float u, float v)
    {
        PsyVkVertex vt{ px / PSYVK_PROJ_WIDTH, py / PSYVK_PROJ_HEIGHT,
                        u, v, 1, 1, 1, 1, (float)slot };
        g_psyvk.vertices.push_back(vt);
    };
    push(x, y, 0, 0); push(x + w, y, 1, 0); push(x, y + h, 0, 1);
    push(x, y + h, 0, 1); push(x + w, y, 1, 0); push(x + w, y + h, 1, 1);
}

static void buildVertices()
{
    g_psyvk.vertices.clear();
    const auto& q = g_psyvk.pendingQuads;
    for (size_t i = 0; i + 5 < q.size(); i += 6)
    {
        float x = q[i], y = q[i + 1], w = q[i + 2], h = q[i + 3], slot = q[i + 4];
        uint32_t color = (uint32_t)q[i + 5];
        float a = ((color >> 24) & 0xFF) / 255.0f;
        float r = ((color >> 16) & 0xFF) / 255.0f;
        float g = ((color >> 8) & 0xFF) / 255.0f;
        float b = (color & 0xFF) / 255.0f;
        auto v = [&](float px, float py, float u, float vv)
        { g_psyvk.vertices.push_back({ px / PSYVK_PROJ_WIDTH, py / PSYVK_PROJ_HEIGHT,
                                       u, vv, r, g, b, a, slot }); };
        v(x, y, 0, 0); v(x + w, y, 1, 0); v(x, y + h, 0, 1);
        v(x, y + h, 0, 1); v(x + w, y, 1, 0); v(x + w, y + h, 1, 1);
    }
    g_psyvk.quads = (uint32_t)(g_psyvk.vertices.size() / 6);
}

bool psyvk_draw_frame()
{
    if (!g_psyvk.created || !g_psyvk.overlayVisible) return false;
    buildVertices();
    if (g_psyvk.vertices.empty()) return false;
    size_t bytes = g_psyvk.vertices.size() * sizeof(PsyVkVertex);
    if (!g_psyvk.vertexMapped) return false;
    memcpy(g_psyvk.vertexMapped, g_psyvk.vertices.data(), bytes);

    uint32_t imageIndex = 0;
    VkResult r = psy_vkAcquireNextImageKHR(g_psyvk.device, g_psyvk.swapchain, UINT64_MAX,
                                           g_psyvk.imageReady, VK_NULL_HANDLE, &imageIndex);
    if (r != VK_SUCCESS) return false;
    psy_vkResetCommandBuffer(g_psyvk.commandBuffer, 0);
    VkCommandBufferBeginInfo begin{ VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO, nullptr,
        VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT, nullptr };
    if (psy_vkBeginCommandBuffer(g_psyvk.commandBuffer, &begin) != VK_SUCCESS) return false;
    VkClearValue clear{ { { 0.0f, 0.0f, 0.0f, 0.0f } } };
    VkRenderPassBeginInfo rp{ VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO, nullptr,
        g_psyvk.renderPass, g_psyvk.framebuffers[imageIndex], { { 0, 0 }, g_psyvk.extent }, 1, &clear };
    psy_vkCmdBeginRenderPass(g_psyvk.commandBuffer, &rp, VK_SUBPASS_CONTENTS_INLINE);
    psy_vkCmdBindPipeline(g_psyvk.commandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS, g_psyvk.pipeline);
    VkDeviceSize offset = 0;
    psy_vkCmdBindVertexBuffers(g_psyvk.commandBuffer, 0, 1, &g_psyvk.vertexBuffer, &offset);
    VkViewport vp{ 0, 0, (float)g_psyvk.extent.width, (float)g_psyvk.extent.height, 0, 1 };
    VkRect2D sc{ { 0, 0 }, g_psyvk.extent };
    psy_vkCmdSetViewport(g_psyvk.commandBuffer, 0, 1, &vp);
    psy_vkCmdSetScissor(g_psyvk.commandBuffer, 0, 1, &sc);
    // Quads are grouped by slot so each group gets its own descriptor set.
    size_t first = 0;
    while (first < g_psyvk.vertices.size())
    {
        float slot = g_psyvk.vertices[first].slot;
        size_t last = first;
        while (last < g_psyvk.vertices.size() && g_psyvk.vertices[last].slot == slot) ++last;
        int si = (int)slot;
        if (si >= 0 && si < PSYVK_MAX_SLOTS && g_psyvk.slots[si].descriptor)
            psy_vkCmdBindDescriptorSets(g_psyvk.commandBuffer, VK_PIPELINE_BIND_POINT_GRAPHICS,
                                        g_psyvk.pipelineLayout, 0, 1,
                                        &g_psyvk.slots[si].descriptor, 0, nullptr);
        psy_vkCmdDraw(g_psyvk.commandBuffer, (uint32_t)(last - first), 1, (uint32_t)first, 0);
        first = last;
    }
    psy_vkCmdEndRenderPass(g_psyvk.commandBuffer);
    if (psy_vkEndCommandBuffer(g_psyvk.commandBuffer) != VK_SUCCESS) return false;

    VkPipelineStageFlags waitStage = VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
    VkSubmitInfo submit{ VK_STRUCTURE_TYPE_SUBMIT_INFO, nullptr,
        1, &g_psyvk.imageReady, &waitStage, 1, &g_psyvk.commandBuffer, 1, &g_psyvk.renderDone };
    if (psy_vkQueueSubmit(g_psyvk.queue, 1, &submit, VK_NULL_HANDLE) != VK_SUCCESS) return false;
    VkPresentInfoKHR present{ VK_STRUCTURE_TYPE_PRESENT_INFO_KHR, nullptr,
        1, &g_psyvk.renderDone, 1, &g_psyvk.swapchain, &imageIndex, nullptr };
    if (psy_vkQueuePresentKHR(g_psyvk.queue, &present) != VK_SUCCESS) return false;
    ++g_psyvk.frames;
    return true;
}
