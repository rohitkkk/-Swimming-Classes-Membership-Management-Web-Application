<%@page import="com.mongodb.client.MongoCursor"%>
<%@page import="com.mongodb.MongoCredential"%>
<%@page import="java.util.Iterator"%>
<%@page import="com.mongodb.client.FindIterable"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.bson.Document"%>
<%@page import="com.mongodb.client.MongoCollection"%>
<%@page import="com.mongodb.client.MongoDatabase"%>
<%@page import="com.mongodb.MongoClient"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="com.mongodb.client.*, com.mongodb.MongoClient, org.bson.Document" %>
<%@ page import="com.mongodb.client.MongoCursor" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swimming Classes Membership Management</title>
    <style>
        body {
            font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0;
            padding: 0;
        }
        .container {
            max-width: 800px; margin: 50px auto; padding: 20px; background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .result {
            padding: 15px;
            background-color: #e9ecef; border-left: 5px solid #17a2b8; margin-bottom: 20px;
        }
        hr {
            margin: 20px 0; border: none;
            border-top: 1px solid #ddd;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>MongoDB Operation Results - Swimming Classes Membership Management</h1>
        <%
            String dbName = "swimmingclassesdb";  
            String collectionName = "swimmingmembers";  
            MongoClient mongoClient = null;
            MongoCollection<Document> collection = null;

            try {
                mongoClient = new MongoClient("localhost", 27017);
                MongoDatabase database = mongoClient.getDatabase(dbName);
                collection = database.getCollection(collectionName);
                String operation = request.getParameter("operation");

                if ("insert".equals(operation)) {
                    String name = request.getParameter("name");
                    String email = request.getParameter("email");
                    String registrationId = request.getParameter("registration_id");
                    String memAddr = request.getParameter("mem_addr");
                    String memType = request.getParameter("mem_type");
                    if (name != null && !name.trim().isEmpty() &&
                        email != null && !email.trim().isEmpty() &&
                        registrationId != null && !registrationId.trim().isEmpty() &&
                        memAddr != null && !memAddr.trim().isEmpty() &&
                        memType != null && !memType.trim().isEmpty()) {
                        
                        Document member = new Document("name", name)
                            .append("email", email)
                            .append("registration_id", registrationId)
                            .append("mem_addr", memAddr)
                            .append("mem_type", memType);
                        collection.insertOne(member);
                        out.println("<div class='result'>Swimming member data inserted successfully!</div>");
                    } else {
                        out.println("<div class='result'>All fields are required.</div>");
                    }
                } else if ("update".equals(operation)) {
                    String registrationId = request.getParameter("registration_id");
                    String newName = request.getParameter("new_name");
                    String newEmail = request.getParameter("new_email");
                    String newMemAddr = request.getParameter("new_mem_addr");
                    String newMemType = request.getParameter("new_mem_type");
                    if (registrationId != null && !registrationId.trim().isEmpty()) {
                        Document query = new Document("registration_id", registrationId);
                        Document update = new Document("$set", new Document("name", newName)
                            .append("email", newEmail)
                            .append("mem_addr", newMemAddr)
                            .append("mem_type", newMemType));
                        long modifiedCount = collection.updateOne(query, update).getModifiedCount();
                        if (modifiedCount > 0) {
                            out.println("<div class='result'>Swimming member details updated successfully!</div>");
                        } else {
                            out.println("<div class='result'>No member found with registration ID: " + registrationId + "</div>");
                        }
                    } else {
                        out.println("<div class='result'>Registration ID is required.</div>");
                    }
                } else if ("delete".equals(operation)) {
                    String registrationId = request.getParameter("registration_id");
                    if (registrationId != null && !registrationId.trim().isEmpty()) {
                        Document query = new Document("registration_id", registrationId);
                        collection.deleteOne(query);
                        out.println("<div class='result'>Swimming member data deleted successfully!</div>");
                    } else {
                        out.println("<div class='result'>Registration ID is required.</div>");
                    }
                } else if ("retrieve".equals(operation)) {
                    MongoCursor<Document> cursor = collection.find().iterator();
                    if (!cursor.hasNext()) {
                        out.println("<div class='result'>No swimming member records found.</div>");
                    } else {
                        out.println("<div class='result'><h3>Swimming Member Data:</h3>");
                        while (cursor.hasNext()) {
                            Document doc = cursor.next();
                            out.println("<strong>Name:</strong> " + doc.getString("name") + "<br>");
                            out.println("<strong>Email:</strong> " + doc.getString("email") + "<br>");
                            out.println("<strong>Registration ID:</strong> " + doc.getString("registration_id") + "<br>");
                            out.println("<strong>Address:</strong> " + doc.getString("mem_addr") + "<br>");
                            out.println("<strong>Membership Type:</strong> " + doc.getString("mem_type") + "<br><hr>");
                        }
                        out.println("</div>");
                    }
                    cursor.close();
                }
            } catch (Exception e) {
                out.println("<div class='result'>Error: " + e.getMessage() + "</div>");
            } finally {
                if (mongoClient != null) {
                    mongoClient.close();
                }
            }
        %>
        <a href="index.html">Go Back to Forms</a>
    </div>
</body>
</html>
