<?php
/**
 * Created by PhpStorm.
 * User: sun
 * Date: 16/6/6
 * Time: 下午8:48
 */


if (!isset($_SERVER['HTTP_USER_AGENT'])) {
    die('请设置User-Agent');
}

//读取HTTP_USER_AGENT
$devicetype = $_SERVER['HTTP_USER_AGENT'];

if (strnatcmp('iOS', $devicetype) == 0) {
    if(empty($_POST['id'])) {
        die('id is empty');
    }
    $id = intval($_POST['id']);
} else {
    if(empty($_GET['id'])) {
        die('id is empty');
    }
    $id = intval($_GET['id']);
}

require_once 'functions.php';

$mysqli = connectDb();
$mysqli->query("DELETE FROM account WHERE id=$id");

if (strnatcmp('iOS', $devicetype) == 0) {
    if ($mysqli->errno) {
        echo '服务器端账目删除 错误原因:'.$mysqli->error;
    } else {
        echo '服务器端账目删除成功 Success';
    }
} else {
    if($mysqli->errno) {
        echo "<script>alert('Operation Failed With Error: '.$mysqli->error);location='http://2.jktimiserver.applinzi.com/accountBook.php';</script>";
    } else {
        echo "<script>alert('Operation Success');location='http://2.jktimiserver.applinzi.com/accountBook.php';</script>";
    }
}