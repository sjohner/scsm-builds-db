<?php

# Include configuration file
require ("config.php");

$q = intval($_GET['q']);

# Create connection
$conn = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);

# Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

# Get user input and build query accordingly
$output = '';
if(isset($_POST["query"])) {
    $search = mysqli_real_escape_string($conn, $_POST["query"]);
    $query = "SELECT * FROM builds LEFT JOIN products ON builds.product = products.id WHERE buildnumber LIKE '%".$search."%'";
}
else {
    $query = "SELECT * FROM builds LEFT JOIN products ON builds.product = products.id ORDER BY buildnumber";
}

# Get query result
$result = mysqli_query($conn, $query);

# Build result page
if(mysqli_num_rows($result) > 0) {
    $output .= '
        <div class="table-responsive">
            <table class="table table bordered">
                <tr>
                    <th>Support Status</th>
                    <th>Build Number</th>
                    <th>KB Article</th>
                    <th>Build</th>
                </tr>
    ';

    while($row = mysqli_fetch_array($result)) {

        $today = date("Y-m-d");
        $expire = $row[mainstreamenddate];

        $today_time = strtotime($today);
        $expire_time = strtotime($expire);

        if ($expire_time < $today_time) { 

            $expire = $row[extendedenddate];

            $today_time = strtotime($today);
            $expire_time = strtotime($expire);
            
            if ($expire_time < $today_time) {

                $output .= '
                    <tr>
                        <td>No support since '.$expire.'</td>
                ';
            }
            else {
                $output .= '
                    <tr>
                        <td>Extended support until '.$expire.'</td>
                ';
            }
        }
        else {
            $output .= '
                    <tr>
                        <td>Mainstream support until '.$expire.'</td>
                ';
        }   

        $output .= '
                <td>'.$row["buildnumber"].'</td>
                <td><a href="'.$row["kbarticleurl"].'">'.$row["kbarticle"].'</a></td>
                <td>'.$row["displayname"].'</td>
            </tr>
        ';
     

        //  if ($row["additionalinfo"] === NULL) {
        //     $output .= '
        //     <tr>
        //         <td>'.$row["buildnumber"].'</td>
        //         <td>'.$row["displayname"].'</td>
        //         <td><a href="'.$row["kbarticleurl"].'">'.$row["kbarticle"].'</a></td>
        //         <td>'
        //     </tr>
        // ';
        // }
        // else {
        //     $output .= '
        //     <tr>
        //         <td>'.$row["buildnumber"].'</td>
        //         <td>'.$row["displayname"].'</td>
        //         <td><a href="'.$row["kbarticleurl"].'">'.$row["kbarticle"].'</a></td>
        //     </tr>
        //     ';
        // } 
    }
        echo $output;
}
else {
    echo 'No data found';
}

?>