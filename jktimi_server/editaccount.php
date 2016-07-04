<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>编辑账目</title>
</head>
<body>
<?php

/**
 * Created by PhpStorm.
 * User: sun
 * Date: 16/6/6
 * Time: 下午8:48
 */

require_once 'functions.php';

if (!empty($_GET['id'])) {
    $mysqli = connectDb();
    $id = intval($_GET['id']);
    $result = $mysqli->query("SELECT * FROM account WHERE id=$id");

    if ($mysqli->errno) {
        die('can not connect db. Error:'.$mysqli->error);
    }
    $arr = mysqli_fetch_assoc($result);
} else {
    die('id not defined');
}

?>

<form action="editaccount_server.php" method="post">
    <div>id
        <input name = "id" type = "text" value = "<?php echo $arr['id']; ?>">
    </div>
    <div>category
        <input name = "category" type = "text" value = "<?php echo $arr['category']; ?>">
    </div>
    <div>money
        <input name = "money" type = "text" value = "<?php echo $arr['money']; ?>">
    </div>
    <div>modifiedtime
        <input name="modifiedtime" type="text" value="<?php echo $arr['modifiedtime']; ?>">
    </div>
    <input type="submit" value = "提交修改">
</form>
</body>
</html>