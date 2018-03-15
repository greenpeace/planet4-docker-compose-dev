define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', true);
define('FS_METHOD', 'direct');
define('SAVEQUERIES', true);
define('SCRIPT_DEBUG', true);

$redis_server = array(
	'host'     => 'redis',
	'port'     => 6379,
	'database' => '0',
);
