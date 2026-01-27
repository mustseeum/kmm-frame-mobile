enum EnvironmentType { dev, staging, prod }

enum CacheManagerKey {
  environmentType,
  authToken,
  userData,
  isLoggedIn,
  rememberMeEmail,
  sessionData,
  loggerApiEnv
}

enum PopupType { warning, info, error, success, refresh, question, failed }

enum PopupButtonType { cancel, ok, yes, no }

enum PopupButtonAction { close, refresh, navigate, none }

enum PopupButtonActionType { close, refresh, navigate, none }

enum PopupButtonActionTypeWithData { close, refresh, navigate, none }

enum ProductType { lens, frame, both }

enum FaceState {
  noFace,
  outsideCircle,
  multipleFaces,
  insideCircle,
  detectorError,
  cameraError,
  permissionDenied,
}

enum PreferenceKey { sample, userDM }

final aesKey = "Gi1oV68mklSFzq9W";

enum Language { id, en }

enum SessionParam { FRAME_ONLY, LENS_ONLY, BOTH }
