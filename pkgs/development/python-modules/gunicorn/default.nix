{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  packaging,

  # optional-dependencies
  eventlet,
  gevent,
  tornado,
  setproctitle,

  pytestCheckHook,
  pytest-cov-stub,
  pytest-asyncio,
  uvloop,
  httpx,
  h2,
}:

buildPythonPackage rec {
  pname = "gunicorn";
  version = "25.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "benoitc";
    repo = "gunicorn";
    tag = version;
    hash = "sha256-r0xkHGU1+5oQH1BXowUKi8FVQ+DqYU3MCYwn8chXf34=";
  };

  build-system = [ setuptools ];

  dependencies = [ packaging ];

  optional-dependencies = {
    gevent = [ gevent ];
    eventlet = [ eventlet ];
    tornado = [ tornado ];
    gthread = [ ];
    setproctitle = [ setproctitle ];
  };

  pythonImportsCheck = [ "gunicorn" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-asyncio
    uvloop
    httpx
    h2
  ]
  ++ lib.flatten (lib.attrValues optional-dependencies);

  pytestFlags = [
    "-vvvvv"
    "-k"
    "test_basic_request"
  ];

  disabledTests = lib.optionals (lib.versionOlder eventlet.version "0.40.3") [
    "TestEventletWorkerAlpn"
  ];

  meta = {
    description = "WSGI HTTP Server for UNIX, fast clients and sleepy applications";
    homepage = "https://github.com/benoitc/gunicorn";
    changelog = "https://github.com/benoitc/gunicorn/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "gunicorn";
  };
}
