<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <title>Microsoft SCSM Builds Database v0.1 - Experts Live Café</title>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css" integrity="sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp" crossorigin="anonymous"> 

        <!-- Fontawesome CSS -->
        <link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet">

        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>

        <script>
            $(document).ready(
                function() {
                    load_data();
                    
                    function load_data(query) {
                        $.ajax({
                            url:"getbuilds.php",
                            method:"POST",
                            data:{query:query},
                            success:function(data)
                            {
                                $('#result').html(data);
                            }
                        });
                    }

                    $('#search_text').keyup(
                        function() {
                            var search = $(this).val();
                            if(search != '') {
                                load_data(search);
                            }
                            else {
                                load_data();
                            }
                        }
                    );
                }
            );
        </script>
    </head>
    <body>
        <div class="container">

            <br />
            <h2 align="center">Search for Microsoft System Center Service Manager Build Number and get corresponding version</h2>
            <br />

            <div class="form-group">
                <div class="input-group">
                    <span class="input-group-addon">Search</span>
                    <input type="text" name="search_text" id="search_text" placeholder="Search by Build Number" class="form-control" />
                </div>
            </div>

            <br />
            <div id="result"></div>
        </div>
    </body>
</html>


