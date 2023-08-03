#include "flutter_window.h"
#include <optional>
#include "flutter/generated_plugin_registrant.h"

#include <string>
#include <flutter/binary_messenger.h>
#include <flutter/standard_method_codec.h>
#include <flutter/method_channel.h>
#include <flutter/method_result_functions.h>
#include <flutter/encodable_value.h>
#include <../standard_codec.cc>
#include "windows.h"
#include "windef.h"
#include "windowsx.h"

FlutterWindow::FlutterWindow(const flutter::DartProject& project)
    : project_(project) {}

FlutterWindow::~FlutterWindow() {}
void initMethodChannel(flutter::FlutterEngine* flutter_instance) {
    const static std::string channel_name("network");
    flutter::BinaryMessenger* messenger = flutter_instance->messenger();
    const flutter::StandardMethodCodec* codec = &flutter::StandardMethodCodec::GetInstance();
    auto channel = std::make_unique<flutter::MethodChannel<>>(messenger ,channel_name ,codec);

        channel->SetMethodCallHandler(
            [](const flutter::MethodCall<>& call,
        std::unique_ptr<flutter::MethodResult<>> result) {
                    flutter::EncodableValue res;

                // check method name called from dart
                if (call.method_name().compare("active_adapter") == 0) {
                res = flutter::EncodableValue("Please work");
                result->Success(res);
                }
                else {
                    result->NotImplemented();
                }
            }
        );
 }
bool FlutterWindow::OnCreate() {
  if (!Win32Window::OnCreate()) {
    return false;
  }

  RECT frame = GetClientArea();

  // The size here must match the window dimensions to avoid unnecessary surface
  // creation / destruction in the startup path.
  flutter_controller_ = std::make_unique<flutter::FlutterViewController>(
      frame.right - frame.left, frame.bottom - frame.top, project_);
  // Ensure that basic setup of the controller was successful.
  if (!flutter_controller_->engine() || !flutter_controller_->view()) {
    return false;
  }
  RegisterPlugins(flutter_controller_->engine());
  initMethodChannel(flutter_controller_->engine());
  SetChildContent(flutter_controller_->view()->GetNativeWindow());

  flutter_controller_->engine()->SetNextFrameCallback([&]() {
    this->Show();
  });

  return true;
}

void FlutterWindow::OnDestroy() {
  if (flutter_controller_) {
    flutter_controller_ = nullptr;
  }

  Win32Window::OnDestroy();
}

LRESULT
FlutterWindow::MessageHandler(HWND hwnd, UINT const message,
                              WPARAM const wparam,
                              LPARAM const lparam) noexcept {
  // Give Flutter, including plugins, an opportunity to handle window messages.
  if (flutter_controller_) {
    std::optional<LRESULT> result =
        flutter_controller_->HandleTopLevelWindowProc(hwnd, message, wparam,
                                                      lparam);
    if (result) {
      return *result;
    }
  }

  switch (message) {
    case WM_FONTCHANGE:
      flutter_controller_->engine()->ReloadSystemFonts();
      break;
  }

  return Win32Window::MessageHandler(hwnd, message, wparam, lparam);
}
