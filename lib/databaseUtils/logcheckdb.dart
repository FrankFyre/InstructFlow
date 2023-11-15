import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  Future<void> logCheckList(String employeeName, String date, String time,
      String checklistName) async {
    try {
      await _databaseReference.child('checklogs').push().set({
        'employeeName': employeeName,
        'date': date,
        'time': time,
        'checklistName': checklistName,
      });
    } catch (error) {
      print('Error logging data: $error');
    }
  }

  Future<void> deleteAndMoveTaskToCompleted(String taskId) async {
    try {
      // Retrieve the task data from the ongoingTasks section.
      final taskSnapshot =
          await _databaseReference.child('ongoingTasks').child(taskId).once();
      var snap = taskSnapshot.snapshot;
      // Check if the task exists in the ongoingTasks section.
      if (snap.value != null) {
        var taskData = Map<String, dynamic>.from(snap.value as Map);

        // Add date and time to the task data.
        taskData['date'] = DateFormat(" dd,MMMM, yyyy").format(DateTime.now());
        taskData['time'] = DateFormat("HH:mm:ss").format(DateTime.now());

        // Remove the task from the ongoingTasks section.
        await _databaseReference.child('ongoingTasks').child(taskId).remove();

        // Add the task to the completedTasks section.
        await _databaseReference
            .child('completedTasks')
            .child(taskId)
            .set(taskData);
      } else {
        // Handle the case where the task doesn't exist.
        print('Task not found in ongoingTasks.');
      }
    } catch (error) {
      // Handle errors, such as database write failures.
      print('Error deleting/moving task: $error');
    }
  }
}
