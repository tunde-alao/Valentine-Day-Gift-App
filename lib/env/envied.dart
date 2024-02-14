import 'package:envied/envied.dart';
part 'envied.g.dart';

@Envied(path: ".env")
abstract class Env {
  @EnviedField(varName: 'OPEN_AI_API_KEY') // the .env variable.
  static const String apiKey = _Env.apiKey;

  @EnviedField(varName: 'YOUR_PARTNERS_NAME') // the .env variable.
  static const String partnerName = _Env.partnerName;
}
