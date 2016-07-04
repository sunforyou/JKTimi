<?php
/**
 * Created by PhpStorm.
 * User: sun
 * Date: 16/6/6
 * Time: 下午11:14
 */

if (!isset($_POST['id'])) {
    die('id is not defined');
}

if (!isset($_POST['category'])) {
    die('category is not defined');
}

if (!isset($_POST['money'])) {
    die('money is not defined');
}

if (!isset($_POST['modifiedtime'])) {
    die('modifiedtime is not defined');
}

if (!isset($_SERVER['HTTP_USER_AGENT'])) {
    die('请设置User-Agent');
}

$id = $_POST['id'];
if (empty($id)) {
    die('id is empty');
}

$category = $_POST['category'];
if (empty($category)) {
    die('category is empty');
}

$money = $_POST['money'];
if (empty($money)) {
    die('money is empty');
}

$modifiedtime = $_POST['modifiedtime'];
if (empty($modifiedtime)) {
    die('modifiedtime is empty');
}

//读取HTTP_USER_AGENT
$devicetype = $_SERVER['HTTP_USER_AGENT'];

require_once "functions.php";

//链接数据库
$mysqli = connectDb();

//防止注入式破坏
$id = intval($_POST['id']);
$category = strval($_POST['category']);
$money = floatval($_POST['money']);
$modifiedtime = $_POST['modifiedtime'];

//插入数据
$result = $mysqli->query("INSERT INTO account(id,category,money,modifiedtime) VALUES('$id','$category','$money','$modifiedtime')");

if (strnatcmp('iOS', $devicetype) == 0) {
    if($mysqli->errno) {
        echo 'Operation Failed With Error: '.$mysqli->error;
    } else {
        echo 'Operation Success';
    }
} else {
    if($mysqli->errno) {
        echo "<script>alert('Operation Failed With Error: '.$mysqli->error);location='http://localhost/MyApp/JKTimi/accountBook.php';</script>";
    } else {
        echo "<script>alert('Operation Success');location='http://localhost/MyApp/JKTimi/accountBook.php';</script>";
    }
}
