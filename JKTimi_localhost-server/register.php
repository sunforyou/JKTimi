<?php
/**
 * Created by PhpStorm.
 * User: sun
 * Date: 16/6/5
 * Time: 下午3:01
 */

if (!isset($_POST['username'])) {
    die('username is not defined');
}

if (!isset($_POST['password'])) {
    die('password is not defined');
}

if (!isset($_SERVER['HTTP_USER_AGENT'])) {
    die('请设置User-Agent');
}

$username = $_POST['username'];
if (empty($username)) {
    die('username is empty');
}

$password = $_POST['password'];
if (empty($password)) {
    die('password is empty');
}

//读取HTTP_USER_AGENT
$devicetype = $_SERVER['HTTP_USER_AGENT'];

require_once "functions.php";

//链接数据库
$mysqli = connectDb();

$username = $_POST['username'];
$password = $_POST['password'];

$username = strval($username);
$password = strval($password);

//验证用户名是否已被注册
$result1 = $mysqli->query("SELECT * FROM users WHERE username LIKE '$username'");
$result1 = @mysqli_fetch_assoc($result1);
$username1 = $result1['username'];

if (strnatcmp('iOS', $devicetype) == 0) {
    /** 针对客户端的响应 */
    //验证用户名
    if (!empty($username1)) {
        echo '该用户名已存在'; return;
    }
    //插入数据
    $result = $mysqli->query("INSERT INTO users(username,password) VALUES('$username','$password')");

    if($mysqli->errno) {
        echo 'Operation Failed With Error: '.$mysqli->error; return;
    }
    echo 'Register Success';

} else {
    /** 针对网页端的响应 */
    if (!empty($username1)) {
        echo "<script>alert('用户名已存在');location = 'http://localhost/MyApp/JKTimi/register.html';</script>";
        return;
    }
    //插入数据
    $result = $mysqli->query("INSERT INTO users(username,password) VALUES('$username','$password')");
    if ($mysqli->errno) {
        echo 'Operation Failed Error: ' . $mysqli->error; return;
    }
    echo "<script>alert('Operation Success');location = 'http://localhost/MyApp/JKTimi/register.html';</script>";
}



