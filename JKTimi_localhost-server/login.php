<?php
/**
 * Created by PhpStorm.
 * User: sun
 * Date: 16/6/4
 * Time: 下午11:52
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

//防止注入式破坏
$username = strval($username);
$password = strval($password);

//验证用户名是否存在
$result1 = $mysqli->query("SELECT * FROM users WHERE username LIKE '$username'");
$result1 = @mysqli_fetch_assoc($result1);
$username1 = $result1['username'];

if (strnatcmp('iOS', $devicetype) == 0) {
    /** 针对客户端的响应 */
    //验证用户名
    if (empty($username1)) {
        echo '用户名不存在,请重新输入'; return;
    }
    //验证密码
    $result = @$mysqli->query("SELECT password FROM users WHERE username LIKE '$username'");
    $result_arr = @mysqli_fetch_array($result);
    if($result_arr['password'] != $password) {
        echo '密码错误,请重新输入'; return;
    }
    echo 'Login Success';
} else {
    /** 针对网页端的响应 */
    if (empty($username1)) {
        echo "<script>alert('用户名不存在,请重新输入');location='http://localhost/MyApp/JKTimi/login.html';</script>";
    }
    //验证密码
    $result = @$mysqli->query("SELECT password FROM users WHERE username LIKE '$username'");
    $result_arr = @mysqli_fetch_array($result);
    if($result_arr['password'] == $password) {
        echo "<script>alert('登录成功');location='http://www.baidu.com';</script>";
    } else {
        echo "<script>alert('用户名或密码错误,请重新输入');location='http://localhost/MyApp/JKTimi/login.html';</script>";
    }
}

