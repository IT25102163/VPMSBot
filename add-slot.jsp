<!DOCTYPE html>
<html>
<head>
    <title>Add New Parking Slot</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .form-container {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
            width: 350px;
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        label {
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 8px;
            margin: 8px 0 15px 0;
            border-radius: 5px;
            border: 1px solid #ccc;
        }

        button {
            width: 100%;
            padding: 10px;
            background-color: #2e86de;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #1b4f72;
        }

        .success {
            color: green;
            text-align: center;
            margin-top: 10px;
        }
    </style>
</head>

<body>

<div class="form-container">
    <h2>Add New Parking Slot</h2>

    <form id="slotForm">
        <label>Slot Number</label>
        <input type="text" id="slotNumber" required>

        <label>Slot Type</label>
        <select id="slotType">
            <option value="Car">Car</option>
            <option value="Bike">Bike</option>
            <option value="Truck">Truck</option>
        </select>

        <label>Status</label>
        <select id="slotStatus">
            <option value="Available">Available</option>
            <option value="Reserved">Reserved</option>
            <option value="Occupied">Occupied</option>
        </select>

        <button type="submit">Add Slot</button>
    </form>

    <div class="success" id="message"></div>
</div>

<script>
    document.getElementById("slotForm").addEventListener("submit", function(event) {
        event.preventDefault();

        let slotNumber = document.getElementById("slotNumber").value;
        let slotType = document.getElementById("slotType").value;
        let slotStatus = document.getElementById("slotStatus").value;

        // Show success message
        document.getElementById("message").innerText =
            "Slot " + slotNumber + " added successfully!";

        console.log("Slot Data:", {
            slotNumber,
            slotType,
            slotStatus
        });

        document.getElementById("slotForm").reset();
    });
</script>

</body>
</html>