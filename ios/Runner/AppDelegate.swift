import UIKit
import Flutter
import supabase_flutter   // ← เพิ่มตรงนี้

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ← เพิ่ม method นี้ เพื่อให้ Supabase SDK จับ URL callback กลับมา
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // ถ้าเป็น URL จาก OAuth flow ของ Supabase ให้ handle
    if Supabase.instance.client.auth.handleAuthURL(url) {
      return true
    }
    // ไม่ใช่ deep‑link ของเรา ก็เรียก superclass ต่อ
    return super.application(app, open: url, options: options)
  }
}
