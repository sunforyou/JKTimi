<?php
require_once 'functions.php';
?>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>账本</title>
</head>
<body>
<a href="addAccount.html">添加账目</a><br>
<table style = 'text-align:center;' border = '1'>
    <tr>
        <th>id</th>
        <th>账目类型</th>
        <th>金额(¥)</th>
        <th>修改时间</th>
        <th>修改</th>
        <th>删除</th>
    </tr>

    <?php
    /**
     * Created by PhpStorm.
     * User: sun
     * Date: 16/6/6
     * Time: 下午8:43
     */

    $mysqli = connectDb();
    //升序ASC 降序DESC
    $result = $mysqli->query("SELECT * FROM account ORDER BY id ASC");
    $data_count = @mysqli_num_rows($result);

    for ($i=0;$i<$data_count;$i++) {
        $result_arr = @mysqli_fetch_array($result);

        $id = $result_arr['id'];
        $category = $result_arr['category'];
        $money = $result_arr['money'];
        $modifiedtime = $result_arr['modifiedtime'];

        echo "<tr>
                <td>$id</td>
                <td>$category</td>
                <td>$money</td>
                <td>$modifiedtime</td>
                <td><a href='editaccount.php?id=$id'>修改</a></td>
                <td><a href='deleteaccount.php?id=$id'>删除</a></td>
          </tr>";
    }
    ?>
</table>
</body>
</html>