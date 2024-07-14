import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminComplainHistoryScreen extends StatefulWidget {
  final String complainType;
  const AdminComplainHistoryScreen({Key? key, required this.complainType}) : super(key: key);

  @override
  _AdminComplainHistoryScreenState createState() => _AdminComplainHistoryScreenState();
}

class _AdminComplainHistoryScreenState extends State<AdminComplainHistoryScreen> {
  late Stream<QuerySnapshot> _complaintStream;

  @override
  void initState() {
    super.initState();
    _complaintStream = FirebaseFirestore.instance
        .collection('complaints')
        .where('complainType', isEqualTo: widget.complainType)
        .snapshots();
  }

  Future<void> _resolveComplaint(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.update(doc.reference, {'status': 'Resolved'});
    });
  }

  Future<void> _deleteComplaint(DocumentSnapshot doc) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.delete(doc.reference);
    });
  }

  void _showResolveConfirmation(DocumentSnapshot complaint) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Resolve'),
          content: Text('Are you sure you want to mark this complaint as resolved?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Resolve'),
              onPressed: () async {
                await _resolveComplaint(complaint);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.complainType} Complaints'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _complaintStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final complaints = snapshot.data!.docs;
          final unresolvedComplaints = complaints.where((doc) => doc['status'] == 'Pending').toList();
          final resolvedComplaints = complaints.where((doc) => doc['status'] == 'Resolved').toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Unresolved Complaints',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.redAccent),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: unresolvedComplaints.length,
                  itemBuilder: (context, index) {
                    final complaint = unresolvedComplaints[index];
                    final complaintData = complaint.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...complaintData.entries.map<Widget>((entry) {
                              return Text(
                                '${entry.key}: ${entry.value}',
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.clip,
                              );
                            }).toList(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: complaint['status'] == 'Resolved'
                                      ? null
                                      : () => _showResolveConfirmation(complaint),
                                  child: Text(
                                    complaint['status'] == 'Resolved'
                                        ? 'Already Resolved'
                                        : 'Click For Resolve',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: complaint['status'] == 'Resolved'
                                        ? Colors.grey
                                        : Colors.orange,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => _deleteComplaint(complaint),
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Resolved Complaints',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(10),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: resolvedComplaints.length,
                  itemBuilder: (context, index) {
                    final complaint = resolvedComplaints[index];
                    final complaintData = complaint.data() as Map<String, dynamic>;

                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...complaintData.entries.map<Widget>((entry) {
                              return Text(
                                '${entry.key}: ${entry.value}',
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.clip,
                              );
                            }).toList(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: null,
                                  child: Text('Already Resolved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => _deleteComplaint(complaint),
                                  child: Text('Delete'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}