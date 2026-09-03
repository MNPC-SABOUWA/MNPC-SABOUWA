class AppConfig {
AppConfig._();

static const String appName = 'MNPC SABOUWA';
static const String appVersion = '2.0.0';

static const String apiBaseUrl =
'https://mnpc-sabouwa-api.onrender.com';

static const Duration connectTimeout = Duration(seconds: 20);

static const Duration receiveTimeout = Duration(seconds: 30);

static const Duration sendTimeout = Duration(seconds: 30);
}
