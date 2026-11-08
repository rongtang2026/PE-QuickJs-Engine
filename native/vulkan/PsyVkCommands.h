#pragma once
// contiguous dot-separated table; we reproduce that table and resolve every
#include <vulkan/vulkan.h>
#include <vulkan/vulkan_android.h>
#include <dlfcn.h>

#define PSYVK_CMD_LIST(X) \
	X(vkAcquireNextImageKHR) \
	X(vkAllocateCommandBuffers) \
	X(vkAllocateDescriptorSets) \
	X(vkAllocateMemory) \
	X(vkBeginCommandBuffer) \
	X(vkBindBufferMemory) \
	X(vkBindImageMemory) \
	X(vkCmdBeginRenderPass) \
	X(vkCmdBindDescriptorSets) \
	X(vkCmdBindPipeline) \
	X(vkCmdBindVertexBuffers) \
	X(vkCmdClearColorImage) \
	X(vkCmdCopyBufferToImage) \
	X(vkCmdDraw) \
	X(vkCmdEndRenderPass) \
	X(vkCmdPipelineBarrier) \
	X(vkCmdSetScissor) \
	X(vkCmdSetViewport) \
	X(vkCreateAndroidSurfaceKHR) \
	X(vkCreateBuffer) \
	X(vkCreateCommandPool) \
	X(vkCreateDescriptorPool) \
	X(vkCreateDescriptorSetLayout) \
	X(vkCreateDevice) \
	X(vkCreateFramebuffer) \
	X(vkCreateGraphicsPipelines) \
	X(vkCreateImage) \
	X(vkCreateImageView) \
	X(vkCreateInstance) \
	X(vkCreatePipelineLayout) \
	X(vkCreateRenderPass) \
	X(vkCreateSampler) \
	X(vkCreateSemaphore) \
	X(vkCreateShaderModule) \
	X(vkCreateSwapchainKHR) \
	X(vkDestroyBuffer) \
	X(vkDestroyCommandPool) \
	X(vkDestroyDevice) \
	X(vkDestroyImage) \
	X(vkDestroyImageView) \
	X(vkDestroyInstance) \
	X(vkDestroySemaphore) \
	X(vkDestroySurfaceKHR) \
	X(vkDestroySwapchainKHR) \
	X(vkDeviceWaitIdle) \
	X(vkEndCommandBuffer) \
	X(vkEnumeratePhysicalDevices) \
	X(vkFreeCommandBuffers) \
	X(vkFreeMemory) \
	X(vkGetBufferMemoryRequirements) \
	X(vkGetDeviceQueue) \
	X(vkGetImageMemoryRequirements) \
	X(vkGetPhysicalDeviceMemoryProperties) \
	X(vkGetPhysicalDeviceProperties) \
	X(vkGetPhysicalDeviceQueueFamilyProperties) \
	X(vkGetPhysicalDeviceSurfaceCapabilitiesKHR) \
	X(vkGetPhysicalDeviceSurfaceFormatsKHR) \
	X(vkGetPhysicalDeviceSurfaceSupportKHR) \
	X(vkGetSwapchainImagesKHR) \
	X(vkMapMemory) \
	X(vkQueuePresentKHR) \
	X(vkQueueSubmit) \
	X(vkResetCommandBuffer) \
	X(vkUpdateDescriptorSets)

#define PSYVK_DECLARE(name) extern PFN_##name psy_##name;
PSYVK_CMD_LIST(PSYVK_DECLARE)

extern void* g_psyvulkan;

#define PSYVK_RAW_TABLE "vkAcquireNextImageKHR.vkAllocateCommandBuffers.vkAllocateDescriptorSets.vkAllocateMemory.vkBeginCommandBuffer.vkBindBufferMemory.vkBindImageMemory.vkCmdBeginRenderPass.vkCmdBindDescriptorSets.vkCmdBindPipeline.vkCmdBindVertexBuffers.vkCmdClearColorImage.vkCmdCopyBufferToImage.vkCmdDraw.vkCmdEndRenderPass.vkCmdPipelineBarrier.vkCmdSetScissor.vkCmdSetViewport.vkCreateAndroidSurfaceKHR.vkCreateBuffer.vkCreateCommandPool.vkCreateDescriptorPool.vkCreateDescriptorSetLayout.vkCreateDevice.vkCreateFramebuffer.vkCreateGraphicsPipelines.vkCreateImage.vkCreateImageView.vkCreateInstance.vkCreatePipelineLayout.vkCreateRenderPass.vkCreateSampler.vkCreateSemaphore.vkCreateShaderModule.vkCreateSwapchainKHR.vkDestroyBuffer.vkDestroyCommandPool.vkDestroyDevice.vkDestroyImage.vkDestroyImageView.vkDestroyInstance.vkDestroySemaphore.vkDestroySurfaceKHR.vkDestroySwapchainKHR.vkDeviceWaitIdle.vkEndCommandBuffer.vkEnumeratePhysicalDevices.vkFreeCommandBuffers.vkFreeMemory.vkGetBufferMemoryRequirements.vkGetDeviceQueue.vkGetImageMemoryRequirements.vkGetPhysicalDeviceMemoryProperties.vkGetPhysicalDeviceProperties.vkGetPhysicalDeviceQueueFamilyProperties.vkGetPhysicalDeviceSurfaceCapabilitiesKHR.vkGetPhysicalDeviceSurfaceFormatsKHR.vkGetPhysicalDeviceSurfaceSupportKHR.vkGetSwapchainImagesKHR.vkMapMemory.vkQueuePresentKHR.vkQueueSubmit.vkResetCommandBuffer.vkSpr.vkUpdateDescriptorSets"

inline bool psyvk_load()
{
    g_psyvulkan = dlopen("libvulkan.so", RTLD_NOW | RTLD_LOCAL);
    if (!g_psyvulkan) return false;
#define PSYVK_RESOLVE(name) \
    psy_##name = reinterpret_cast<PFN_##name>(dlsym(g_psyvulkan, #name)); \
    if (!psy_##name) return false;
    PSYVK_CMD_LIST(PSYVK_RESOLVE)
#undef PSYVK_RESOLVE
    return true;
}

inline void psyvk_unload()
{
    if (g_psyvulkan) { dlclose(g_psyvulkan); g_psyvulkan = nullptr; }
}
