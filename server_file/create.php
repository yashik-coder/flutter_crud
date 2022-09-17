<?php

    $connection = new mysqli("localhost","root","","imagedb");



    //get image name
    $image = $_FILES['image']['name']; 
    $name = $_POST["name"];

    //create date now
    $date = date('Y-m-d');

    //make image path
    $imagePath = 'images/'.$image; 

    $tmp_name = $_FILES['image']['tmp_name']; 

    //move image to images folder
    move_uploaded_file($tmp_name, $imagePath);

     if($image!==null){
        $result = mysqli_query($connection, "insert into flutter_upload_images set image='$image', date='$date',name='$name'");
    
        if($result){
            echo json_encode([
                'message' => 'Data input successfully'
            ]);
        }else{
            echo json_encode([
                'message' => 'Data Failed to input'
            ]);
        }
     }else{
        echo 'Please Select a Image';
     }

?>