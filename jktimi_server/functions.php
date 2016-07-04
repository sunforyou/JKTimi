<?php
/**
 * Created by PhpStorm.
 * User: sun
 * Date: 16/6/3
 * Time: 下午12:19
 */

function connectDb() {

    $hostname = SAE_MYSQL_HOST_M;
    $hostport = SAE_MYSQL_PORT;
    $dbuser = SAE_MYSQL_USER;
    $dbpass = SAE_MYSQL_PASS;
    $dbname = SAE_MYSQL_DB;

    /** mysqli系列函数不支持"host:port"的写法。port是作为参数传进去的 */
    $mysqli = @new mysqli($hostname, $dbuser, $dbpass, $dbname, $hostport);

    /** 连接服务器 */
    if ($mysqli->connect_error) {
        die('Could not connect: ' . mysqli_connect_error());
    }
    
    /** 选取数据库 */
    $mysqli->select_db($dbname) or die ('Can\'t use dbname : ' . $mysqli->connect_error);
    return $mysqli;
}
