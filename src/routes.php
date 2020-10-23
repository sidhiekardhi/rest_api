<?php

use Slim\App;
use Slim\Http\Request;
use Slim\Http\Response;

return function (App $app) {



    // $app->get('/view', function($request, $response, $args){
    //     $tbl = $this->db->prepare('select * from person order by id asc');
    //     $tbl->execute();
    //     $response= $tbl->fetchAll();
    //     return $this->response->withJson($response);
    // }); 


    $app->get("/getUser/", function (Request $request, Response $response){
        $sql = "SELECT * FROM user";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $response->withJson(["status" => "success", "data" => $result], 200);
    });

    $app->get("/getListUser/{id}", function (Request $request, Response $response, $args){
        $id = $args["id"];
        $sql = "SELECT * FROM user WHERE id=:id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([":id" => $id]);
        $result = $stmt->fetch();
        return $response->withJson(["status" => "success", "data" => $result], 200);
    });

    $app->get("/getCompany/", function (Request $request, Response $response){
        $sql = "SELECT * FROM company";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $response->withJson(["status" => "success", "data" => $result], 200);
    });

    $app->get("/getListCompany/{id}", function (Request $request, Response $response, $args){
        $id = $args["id"];
        $sql = "SELECT * FROM company WHERE id=:id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([":id" => $id]);
        $result = $stmt->fetch();
        return $response->withJson(["status" => "success", "data" => $result], 200);
    });

    $app->get("/getBudgetCompany/", function (Request $request, Response $response){
        $sql = "SELECT * FROM company_budget";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $response->withJson(["status" => "success", "data" => $result], 200);
    });

    $app->get("/getLogTransaction/", function (Request $request, Response $response){
        $sql = "SELECT u.first_name, u.last_name, u.account, c.name, t.type, t.date, t.amount, cb.amount- t.amount as 'budget_now'  FROM transaction t LEFT JOIN user u ON (t.user_id= u.id) LEFT JOIN company c ON (c.id=u.company_id) LEFT JOIN company_budget cb ON(cb.company_id=c.id)";
        $stmt = $this->db->prepare($sql);
        $stmt->execute();
        $result = $stmt->fetchAll();
        return $response->withJson(["status" => "success", "data" => $result], 200);
    });

    $app->get("/getListBudgetCompany/{id}", function (Request $request, Response $response, $args){
        $id = $args["id"];
        $sql = "SELECT * FROM company_budget WHERE id=:id";
        $stmt = $this->db->prepare($sql);
        $stmt->execute([":id" => $id]);
        $result = $stmt->fetch();
        return $response->withJson(["status" => "success", "data" => $result], 200);
    });

    $app->post("/createUser/", function (Request $request, Response $response){

        $new_user = $request->getParsedBody();
    
        $sql = "INSERT INTO user (first_name, last_name, email, account, company_id) VALUE (:first_name, :last_name, :email, :account, :company_id)";
        $stmt = $this->db->prepare($sql);
    
        $data = [
            ":first_name" => $new_user["first_name"],
            ":last_name" => $new_user["last_name"],
            ":email" => $new_user["email"],
            ":account" => $new_user["account"],
            ":company_id" => $new_user["company_id"]
        ];
    
        if($stmt->execute($data))
           return $response->withJson(["status" => "success", "data" => $data], 200);
        
        return $response->withJson(["status" => "failed", "data" => "0"], 200);
    });

    $app->post("/createCompany/", function (Request $request, Response $response){

        $new_user = $request->getParsedBody();
    
        $sql = "INSERT INTO company (name, address) VALUE (:name, :address)";
        $stmt = $this->db->prepare($sql);
    
        $data = [
            ":name" => $new_user["name"],
            ":address" => $new_user["address"]
        ];
    
        if($stmt->execute($data))
           return $response->withJson(["status" => "success", "data" => $data], 200);
        
        return $response->withJson(["status" => "failed", "data" => "0"], 200);
    });

    $app->put("/updateCompany/{id}", function (Request $request, Response $response, $args){
        $id = $args["id"];
        $update_company = $request->getParsedBody();
        $sql = "UPDATE company SET name=:name, address=:address WHERE id=:id";
        $stmt = $this->db->prepare($sql);
        
        $data = [
            ":id" => $id,
            ":name" => $update_company["name"],
            ":address" => $update_company["address"]
        ];
    
        if($stmt->execute($data))
           return $response->withJson(["status" => "success", "data" => $data], 200);
        
        return $response->withJson(["status" => "failed", "data" => "0"], 200);
    });

    $app->put("/updateUser/{id}", function (Request $request, Response $response, $args){
        $id = $args["id"];
        $update_user = $request->getParsedBody();
        $sql = "UPDATE user SET first_name=:first_name, last_name=:last_name, email=:email, account=:account, company_id=:company_id WHERE id=:id";
        $stmt = $this->db->prepare($sql);
        
        $data = [
            ":id" => $id,
            ":first_name" => $update_user["first_name"],
            ":last_name" => $update_user["last_name"],
            ":email" => $update_user["email"],
            ":account" => $update_user["account"],
            ":company_id" => $update_user["company_id"]
        ];
    
        if($stmt->execute($data))
           return $response->withJson(["status" => "success", "data" => $data], 200);
        
        return $response->withJson(["status" => "failed", "data" => "0"], 200);
    });

    $app->delete("/deleteUser/{id}", function (Request $request, Response $response, $args){
        $id = $args["id"];
        $sql = "DELETE FROM user WHERE id=:id";
        $stmt = $this->db->prepare($sql);
        
        $data = [
            ":id" => $id
        ];
    
        if($stmt->execute($data))
           return $response->withJson(["status" => "success", "data" => "1"], 200);
        
        return $response->withJson(["status" => "failed", "data" => "0"], 200);
    });

    $app->delete("/deleteCompany/{id}", function (Request $request, Response $response, $args){
        $id = $args["id"];
        $sql = "DELETE FROM company WHERE id=:id";
        $stmt = $this->db->prepare($sql);
        
        $data = [
            ":id" => $id
        ];
    
        if($stmt->execute($data))
           return $response->withJson(["status" => "success", "data" => "1"], 200);
        
        return $response->withJson(["status" => "failed", "data" => "0"], 200);
    });

    $container = $app->getContainer();

    $app->get('/[{name}]', function (Request $request, Response $response, array $args) use ($container) {
        // Sample log message
        $container->get('logger')->info("Slim-Skeleton '/' route");

        // Render index view
        return $container->get('renderer')->render($response, 'index.phtml', $args);
    });

    


};
