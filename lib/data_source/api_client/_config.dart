const bool useDevApi = false;

const String baseUrl = useDevApi
  ? 'https://dev.etv.tudelft.nl/api/v1'
  : 'https://etv.tudelft.nl/api/v1';

const String authHeaderName = 'Authorization';

const Map<String, String> defaultHeaders = {};
