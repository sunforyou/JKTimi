<?php
/**
 * Created by PhpStorm.
 * User: sun
 * Date: 16/5/31
 * Time: 上午10:27
 */

require_once 'config.php';

function connectDb() {
    /** mysqli系列函数不支持"host:port"的写法。port是作为参数传进去的 */
    $mysqli = @new mysqli(MYSQL_HOST, MYSQL_USER, MYSQL_PW, MYSQL_DB, MYSQL_PORT);

    /** 连接服务器 */
    if ($mysqli->connect_errno) {
        die('Could not connect: ' . mysqli_connect_error());
    }
//    echo 'Connected successfully<br/>';
    /** 选取数据库 */
    $mysqli->select_db(MYSQL_DB) or die ('Can\'t use dbname : ' . $mysqli->connect_error);
//    echo 'Select db '.$dbname.' successfully';
    return $mysqli;
}
