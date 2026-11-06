package DingLing.pe.QuickJs.Engine;

import android.app.ActivityManager;
import android.content.Context;
import android.os.Debug;
import android.os.Process;
import org.haxe.extension.Extension;

/* loaded from: D:\FNF\job\_re\raw\classes5.dex */
public class MemoryInfoHelper {
    private static ActivityManager activityManager() {
        Context context = Extension.mainContext;
        if (context == null) {
            return null;
        }
        try {
            return (ActivityManager) context.getSystemService("activity");
        } catch (Throwable th) {
            return null;
        }
    }

    public static double getAvailableRamMB() {
        ActivityManager activityManager = activityManager();
        if (activityManager == null) {
            return -1.0d;
        }
        try {
            activityManager.getMemoryInfo(new ActivityManager.MemoryInfo());
            return r3.availMem / 1048576.0d;
        } catch (Throwable th) {
            return -1.0d;
        }
    }

    public static double getPrivateDirtyMB() {
        Debug.MemoryInfo processMemoryInfo = processMemoryInfo();
        if (processMemoryInfo != null) {
            try {
                int totalPrivateDirty = processMemoryInfo.getTotalPrivateDirty();
                if (totalPrivateDirty > 0) {
                    return totalPrivateDirty / 1024.0d;
                }
            } catch (Throwable th) {
            }
        }
        try {
            long pss = Debug.getPss();
            if (pss > 0) {
                return pss / 1024.0d;
            }
            return -1.0d;
        } catch (Throwable th2) {
            return -1.0d;
        }
    }

    public static double getPssMB() {
        if (processMemoryInfo() == null) {
            return -1.0d;
        }
        try {
            return r0.getTotalPss() / 1024.0d;
        } catch (Throwable th) {
            return -1.0d;
        }
    }

    public static double getTotalRamMB() {
        ActivityManager activityManager = activityManager();
        if (activityManager == null) {
            return -1.0d;
        }
        try {
            activityManager.getMemoryInfo(new ActivityManager.MemoryInfo());
            return r3.totalMem / 1048576.0d;
        } catch (Throwable th) {
            return -1.0d;
        }
    }

    private static Debug.MemoryInfo processMemoryInfo() {
        Debug.MemoryInfo[] processMemoryInfo;
        Context context = Extension.mainContext;
        if (context != null) {
            try {
                ActivityManager activityManager = (ActivityManager) context.getSystemService("activity");
                if (activityManager != null && (processMemoryInfo = activityManager.getProcessMemoryInfo(new int[]{Process.myPid()})) != null && processMemoryInfo.length > 0) {
                    return processMemoryInfo[0];
                }
            } catch (Throwable th) {
            }
        }
        try {
            Debug.MemoryInfo memoryInfo = new Debug.MemoryInfo();
            Debug.getMemoryInfo(memoryInfo);
            return memoryInfo;
        } catch (Throwable th2) {
            return null;
        }
    }
}
