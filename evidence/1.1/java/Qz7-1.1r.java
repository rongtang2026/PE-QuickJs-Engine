package DingLing.pe.QuickJs.Engine;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.content.pm.SigningInfo;
import android.os.Build;
import java.security.MessageDigest;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import org.haxe.extension.Extension;

/* loaded from: D:\FNF\job\_re\dex_1.1r\classes5.dex */
public class Qz7 {
    private static byte[] c;

    public static int a(int i) {
        byte[] v = v();
        if (v == null || v.length < 32 || i < 0 || i > 7) {
            return 0;
        }
        int i2 = i * 4;
        return ((v[i2] & 255) << 24) | ((v[i2 + 1] & 255) << 16) | ((v[i2 + 2] & 255) << 8) | (v[i2 + 3] & 255);
    }

    public static int b() {
        try {
            Context context = Extension.mainContext;
            if (context == null) {
                return 0;
            }
            PackageManager packageManager = context.getPackageManager();
            String packageName = context.getPackageName();
            if (Build.VERSION.SDK_INT < 28) {
                PackageInfo packageInfo = packageManager.getPackageInfo(packageName, 64);
                if (packageInfo != null && packageInfo.signatures != null) {
                    return packageInfo.signatures.length;
                }
                return 0;
            }
            PackageInfo packageInfo2 = packageManager.getPackageInfo(packageName, 134217728);
            SigningInfo signingInfo = packageInfo2 == null ? null : packageInfo2.signingInfo;
            if (signingInfo == null) {
                return 0;
            }
            Signature[] apkContentsSigners = signingInfo.hasMultipleSigners() ? signingInfo.getApkContentsSigners() : signingInfo.getSigningCertificateHistory();
            if (apkContentsSigners == null) {
                return 0;
            }
            return apkContentsSigners.length;
        } catch (Throwable th) {
            return 0;
        }
    }

    public static int c() {
        try {
            Context context = Extension.mainContext;
            if (context == null) {
                return -1;
            }
            return (context.getApplicationInfo().flags & 2) != 0 ? 1 : 0;
        } catch (Throwable th) {
            return -1;
        }
    }

    public static int d() {
        int i = 0;
        try {
            Context context = Extension.mainContext;
            if (context == null) {
                return 0;
            }
            ZipFile zipFile = new ZipFile(context.getPackageCodePath());
            boolean z = false;
            int i2 = 0;
            int i3 = 0;
            Enumeration<? extends ZipEntry> entries = zipFile.entries();
            while (entries.hasMoreElements()) {
                String name = entries.nextElement().getName();
                if (!name.startsWith("assets/")) {
                    if (name.startsWith("classes") && name.endsWith(".dex")) {
                        i2++;
                        String substring = name.substring("classes".length(), name.length() - ".dex".length());
                        if (substring.length() < 1) {
                            z = true;
                        } else {
                            try {
                                int parseInt = Integer.parseInt(substring);
                                if (parseInt < 2) {
                                    i |= 1;
                                }
                                if (parseInt > i3) {
                                    i3 = parseInt;
                                }
                            } catch (NumberFormatException e) {
                                i |= 1;
                            }
                        }
                    } else if (name.startsWith("lib/")) {
                        if (!okSo(name)) {
                            i |= 2;
                        }
                    } else if (!name.startsWith("res/") && !name.startsWith("META-INF/") && !name.startsWith("kotlin/") && (name.indexOf(47) >= 0 || !okRoot(name))) {
                        i |= 4;
                    }
                }
            }
            zipFile.close();
            if (!z) {
                i |= 1;
            }
            return i2 != Math.max(1, i3) ? i | 1 : i;
        } catch (Throwable th) {
            return 0;
        }
    }

    public static int e() {
        int i;
        try {
            Context context = Extension.mainContext;
            if (context == null) {
                return 0;
            }
            ApplicationInfo applicationInfo = context.getApplicationInfo();
            int i2 = (applicationInfo.flags & 2) != 0 ? 0 | 1 : 0;
            int i3 = 0;
            PackageManager packageManager = context.getPackageManager();
            String packageName = context.getPackageName();
            if (Build.VERSION.SDK_INT >= 28) {
                PackageInfo packageInfo = packageManager.getPackageInfo(packageName, 134217728);
                SigningInfo signingInfo = packageInfo == null ? null : packageInfo.signingInfo;
                if (signingInfo != null) {
                    Signature[] apkContentsSigners = signingInfo.hasMultipleSigners() ? signingInfo.getApkContentsSigners() : signingInfo.getSigningCertificateHistory();
                    i3 = apkContentsSigners == null ? 0 : apkContentsSigners.length;
                }
            } else {
                PackageInfo packageInfo2 = packageManager.getPackageInfo(packageName, 64);
                if (packageInfo2 != null && packageInfo2.signatures != null) {
                    i = packageInfo2.signatures.length;
                    i3 = i;
                }
                i = 0;
                i3 = i;
            }
            if (i3 > 255) {
                i3 = 255;
            }
            int i4 = i2 | (i3 << 8);
            int i5 = 0;
            try {
                i5 = applicationInfo.splitSourceDirs != null ? applicationInfo.splitSourceDirs.length : 0;
            } catch (Throwable th) {
            }
            if (i5 > 255) {
                i5 = 255;
            }
            return i4 | (i5 << 16);
        } catch (Throwable th2) {
            return 0;
        }
    }

    private static boolean okRoot(String str) {
        return str.equals("AndroidManifest.xml") || str.equals("resources.arsc") || str.equals("DebugProbesKt.bin");
    }

    private static boolean okSo(String str) {
        int lastIndexOf = str.lastIndexOf(47);
        if (lastIndexOf < 0) {
            return false;
        }
        String substring = str.substring(lastIndexOf + 1);
        return substring.equals("libApplicationMain.so") || substring.equals("libc++_shared.so") || substring.equals("liblime.so") || substring.equals("libvlc.so");
    }

    private static byte[] v() {
        byte[] bArr = c;
        if (bArr != null) {
            return bArr;
        }
        try {
            Context context = Extension.mainContext;
            if (context == null) {
                return null;
            }
            PackageManager packageManager = context.getPackageManager();
            String packageName = context.getPackageName();
            Signature[] signatureArr = null;
            if (Build.VERSION.SDK_INT >= 28) {
                PackageInfo packageInfo = packageManager.getPackageInfo(packageName, 134217728);
                SigningInfo signingInfo = packageInfo == null ? null : packageInfo.signingInfo;
                if (signingInfo != null) {
                    signatureArr = signingInfo.hasMultipleSigners() ? signingInfo.getApkContentsSigners() : signingInfo.getSigningCertificateHistory();
                }
            } else {
                PackageInfo packageInfo2 = packageManager.getPackageInfo(packageName, 64);
                signatureArr = packageInfo2 == null ? null : packageInfo2.signatures;
            }
            if (signatureArr != null && signatureArr.length >= 1) {
                byte[] digest = MessageDigest.getInstance("SHA-256").digest(signatureArr[0].toByteArray());
                c = digest;
                return digest;
            }
            return null;
        } catch (Throwable th) {
            return null;
        }
    }
}
