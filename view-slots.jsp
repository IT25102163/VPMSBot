<!DOCTYPE html>
<html>
<head>
  <title>View Parking Slots</title>
  <style>
    body {
      font-family: Arial;
      background-color: #f4f6f9;
      padding: 20px;
    }

    h2 {
      text-align: center;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      background: white;
    }

    th, td {
      padding: 10px;
      text-align: center;
      border: 1px solid #ddd;
    }

    th {
      background-color: #2e86de;
      color: white;
    }

    button {
      padding: 5px 10px;
      margin: 2px;
      border: none;
      border-radius: 5px;
      cursor: pointer;
    }

    .edit-btn {
      background-color: orange;
      color: white;
    }

    .delete-btn {
      background-color: red;
      color: white;
    }

    .save-btn {
      background-color: green;
      color: white;
    }
  </style>
</head>
<body>

<h2>Parking Slot List</h2>

<table id="slotTable">
  <thead>
  <tr>
    <th>Slot No</th>
    <th>Type</th>
    <th>Status</th>
    <th>Actions</th>
  </tr>
  </thead>
  <tbody>
  </tbody>
</table>

<script>
  let slots = [
    {slotNo: "A1", type: "Car", status: "Available"},
    {slotNo: "B2", type: "Bike", status: "Occupied"},
    {slotNo: "C3", type: "Truck", status: "Reserved"}
  ];

  function loadTable() {
    let tableBody = document.querySelector("#slotTable tbody");
    tableBody.innerHTML = "";

    slots.forEach((slot, index) => {
      let row = `
                <tr>
                    <td>${slot.slotNo}</td>
                    <td>${slot.type}</td>
                    <td>${slot.status}</td>
                    <td>
                        <button class="edit-btn" onclick="editSlot(${index})">Edit</button>
                        <button class="delete-btn" onclick="deleteSlot(${index})">Delete</button>
                    </td>
                </tr>
            `;
      tableBody.innerHTML += row;
    });
  }

  function editSlot(index) {
    let slot = slots[index];

    let newStatus = prompt("Enter new status (Available/Occupied/Reserved):", slot.status);

    if (newStatus !== null) {
      slots[index].status = newStatus;
      loadTable();
    }
  }

  function deleteSlot(index) {
    if (confirm("Are you sure you want to delete this slot?")) {
      slots.splice(index, 1);
      loadTable();
    }
  }

  loadTable();
</script>

</body>
</html>
