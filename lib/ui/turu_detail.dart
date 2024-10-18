import 'package:flutter/material.dart';
import '/model/turu.dart';
import '/ui/turu_form.dart';
import '/utilities/constants.dart'; // Assuming you have a constants file for styling
import '/bloc/turu_bloc.dart';

class PemantauanTidurDetail extends StatefulWidget {
  PemantauanTidur? pemantauanTidur;

  PemantauanTidurDetail({Key? key, this.pemantauanTidur}) : super(key: key);

  @override
  _PemantauanTidurDetailState createState() => _PemantauanTidurDetailState();
}

class _PemantauanTidurDetailState extends State<PemantauanTidurDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pemantauan Tidur'),
        backgroundColor: const Color.fromARGB(255, 243, 160, 5),
      ),
      backgroundColor: const Color.fromARGB(255, 251, 255, 210),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSleepDetailRow("Sleep Quality",
                  widget.pemantauanTidur!.sleepQuality.toString()),
              _buildSleepDetailRow(
                  "Sleep Hours", widget.pemantauanTidur!.sleepHours.toString()),
              _buildSleepDetailRow("Sleep Disorders",
                  widget.pemantauanTidur!.sleepDisorders.toString()),
              const SizedBox(height: 30.0),
              _tombolHapusEdit(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSleepDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: kLabelStyle.copyWith(
              color: const Color.fromARGB(255, 243, 160, 5),
              fontFamily: 'Helvetica',
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18.0,
                color: Color.fromARGB(255, 243, 160, 5),
                fontFamily: 'Helvetica',
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Tombol Edit
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PemantauanTidurForm(
                    pemantauanTidur: widget
                        .pemantauanTidur, // Pass the existing data for editing
                  ),
                ),
              ).then((value) {
                if (value == true) {
                  // Refresh the page or go back to update the list if needed
                  Navigator.pop(context, true);
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 243, 160, 5),
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              "EDIT",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 214, 102),
                fontFamily: 'Helvetica',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 10.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () => confirmHapus(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 255, 102,
                  102), // Matching form's button style for 'Delete'
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: const Text(
              "DELETE",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 214, 102),
                fontFamily: 'Helvetica',
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void confirmHapus() {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: const Color.fromARGB(255, 255, 255, 224),
      content: const Text(
        "Yakin ingin menghapus data ini?",
        style: TextStyle(
          color: Color.fromARGB(255, 243, 160, 5),
          fontSize: 18.0,
          fontFamily: 'Helvetica',
        ),
      ),
      actions: [
        ElevatedButton(
          child: const Text("Ya"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 243, 160, 5),
          ),
          onPressed: () async {
            var response = await PemantauanTidurBloc.deletePemantauanTidur(
                id: widget.pemantauanTidur!.id);

            if (response == true) {
              // Success - Show a snackbar and navigate back
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data berhasil dihapus!')));
              Navigator.pop(context); // Close the dialog
              Navigator.pop(
                  context, true); // Return to previous page and trigger refresh
            } else {
              // Failure - Show a snackbar
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menghapus data!')));
              Navigator.pop(context); // Close the dialog
            }
          },
        ),
        ElevatedButton(
          child: const Text("Batal"),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 243, 160, 5),
          ),
          onPressed: () => Navigator.pop(context),
        )
      ],
    );

    showDialog(builder: (context) => alertDialog, context: context);
  }
}
