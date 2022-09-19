<?php
    

    $servername = "localhost";
    $username = "root";
    $password = "";
    $dbname = "testdb";
    $table = "Employees"; // lets create a table named Employees.

    $action = $_POST["action"];
    
     // Create Connection
     $conn = new mysqli($servername, $username, $password, $dbname);
     // Check Connection
     if($conn->connect_error){
         die("Connection Failed: " . $conn->connect_error);
         return;
     }else{
        //echo 'Connection Successfully!';
     }


    // If the app sends an action to create the table...
     if("CREATE_TABLE" == $action){
        $sql = "CREATE TABLE IF NOT EXISTS $table ( 
            id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            first_name VARCHAR(30) NOT NULL,
            last_name VARCHAR(30) NOT NULL
            )";
 
        if($conn->query($sql) === TRUE){
            // send back success message
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }


     // Get all employee records from the database
     if("GET_ALL" == $action){
        $i=1;
        $db_data = array();
        $sql = "SELECT id, first_name, last_name,image from $table ORDER BY id DESC";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $db_data[]=array(
                    'count'=>$i++,
                    'first_name'=>$row['first_name'],
                    'last_name'=>$row['last_name'],
                    'image'=>$row['image'],
                    'id'=>$row['id'],
                );

                      }
            // Send back the complete records as a json
            echo json_encode($db_data);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }


     // Add an Employee
     if("ADD_EMP" == $action){
        // App will be posting these values to this server
        $first_name = $_POST["first_name"];
        $last_name = $_POST["last_name"];

        $image = $_FILES['image']['name']; 
       

        $date = date('Y-m-d');

        
        //make image path
        $imagePath = 'images/'.$image;  

        $tmp_name = $_FILES['image']['tmp_name']; 

        //move image to images folder
        move_uploaded_file($tmp_name, $imagePath);


            if($image!==null){

                $sql = "INSERT INTO $table (first_name, last_name, image , date) VALUES ('$first_name', '$last_name' ,'$image' , '$date')";
                $result = $conn->query($sql);
                echo "success";
                $conn->close();
                return;
            }
           
    }


     // Update an Employee
     if("UPDATE_EMP" == $action){
        // App will be posting these values to this server
        $emp_id = $_POST['emp_id'];
        $first_name = $_POST["first_name"];
        $last_name = $_POST["last_name"];
        $previous_img = $_POST["previous_img"];
        $image = $_FILES['image']['name']; 

       


       
      

        if($image!=null){
               //make image path
         $imagePath = 'images/'.$image;  

         $tmp_name = $_FILES['image']['tmp_name']; 
 
         //move image to images folder
         move_uploaded_file($tmp_name, $imagePath);
            $deleteimagePath = 'images/'.$previous_img;
            unlink($deleteimagePath);
        
            $sql = "UPDATE $table SET first_name = '$first_name', last_name = '$last_name',image = '$image' WHERE id = $emp_id";
            if($conn->query($sql) === TRUE){
                echo "success";
            }else{
                echo "error";
            }
            $conn->close();
            return;



        }else{
            $sql = "UPDATE $table SET first_name = '$first_name', last_name = '$last_name' WHERE id = $emp_id";
            if($conn->query($sql) === TRUE){
                echo "success";
            }else{
                echo "error";
            }
            $conn->close();
            return;


        }
  


     

    }


      // Delete an Employee
      if('DELETE_EMP' == $action){
        $emp_id = $_POST['emp_id'];
        $image_name = $_POST["image_name"];
        $imagePath = 'images/'.$image_name; 


        

        $sql = "DELETE FROM $table WHERE id = $emp_id"; // don't need quotes since id is an integer.
        if($conn->query($sql) === TRUE){
            unlink($imagePath);
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }

?>
