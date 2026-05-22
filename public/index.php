<?php

use App\Kernel;
use Symfony\Component\ErrorHandler\Debug;

require_once dirname(__DIR__).'/vendor/autoload.php';

// Load variables gikan sa .env file (para sa APP_ENV ug APP_DEBUG)
if (is_file(dirname(__DIR__).'/vendor/autoload_runtime.php')) {
    require_once dirname(__DIR__).'/vendor/autoload_runtime.php';
}

$appDebug = (bool) ($_SERVER['APP_DEBUG'] ?? false);
$appEnv = $_SERVER['APP_ENV'] ?? 'prod';

if ($appDebug) {
    umask(0000);
    Debug::enable();
}

$kernel = new Kernel($appEnv, $appDebug);
$request = \Symfony\Component\HttpFoundation\Request::createFromGlobals();
$response = $kernel->handle($request);
$response->send();
$kernel->terminate($request, $response);