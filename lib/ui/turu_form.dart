import 'package:flutter/material.dart';
import '/model/turu.dart';
import '/utilities/constants.dart';
import '/bloc/turu_bloc.dart';

// ignore: must_be_immutable
class PemantauanTidurForm extends StatefulWidget {
  PemantauanTidur? pemantauanTidur;
  PemantauanTidurForm({Key? key, this.pemantauanTidur}) : super(key: key);

  @override
  _PemantauanTidurFormState createState() => _PemantauanTidurFormState();
}

class _PemantauanTidurFormState extends State<PemantauanTidurForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH DATA TIDUR";
  String tombolSubmit = "SIMPAN";
  final _sleepQualityTextboxController = TextEditingController();
  final _sleepHoursTextboxController = TextEditingController();
  final _sleepDisordersTextboxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.pemantauanTidur != null) {
      setState(() {
        judul = "UBAH DATA TIDUR";
        tombolSubmit = "UBAH";
        _sleepQualityTextboxController.text =
            widget.pemantauanTidur!.sleepQuality!;
        _sleepHoursTextboxController.text =
            widget.pemantauanTidur!.sleepHours.toString();
        _sleepDisordersTextboxController.text =
            widget.pemantauanTidur!.sleepDisorders!;
      });
    } else {
      judul = "TAMBAH DATA TIDUR";
      tombolSubmit = "SIMPAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(judul),
        backgroundColor: const Color.fromARGB(255, 243, 160, 5),
      ),
      backgroundColor: const Color.fromARGB(255, 251, 255, 10),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildSleepQualityTF(),
                const SizedBox(height: 30.0),
                _buildSleepHoursTF(),
                const SizedBox(height: 30.0),
                _buildSleepDisordersTF(),
                const SizedBox(height: 30.0),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Updated Sleep Quality TextField with consistent UI style
  Widget _buildSleepQualityTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sleep Quality',
          style: kLabelStyle.copyWith(
              color: const Color.fromARGB(255, 243, 160, 5)),
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _sleepQualityTextboxController,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Helvetica',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.bedtime,
                color: Color.fromARGB(255, 243, 160, 5),
              ),
              hintText: 'Enter Sleep Quality',
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Sleep Quality harus diisi";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  // Updated Sleep Hours TextField with consistent UI style
  Widget _buildSleepHoursTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sleep Hours',
          style: kLabelStyle.copyWith(
              color: const Color.fromARGB(255, 243, 160, 5)),
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _sleepHoursTextboxController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Helvetica',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.access_time,
                color: Color.fromARGB(255, 243, 160, 5),
              ),
              hintText: 'Enter Sleep Hours',
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Sleep Hours harus diisi";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSleepDisordersTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Sleep Disorders',
          style: kLabelStyle.copyWith(
              color: const Color.fromARGB(255, 243, 160, 5)),
        ),
        const SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _sleepDisordersTextboxController,
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Helvetica',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.health_and_safety,
                color: Color.fromARGB(255, 243, 160, 5),
              ),
              hintText: 'Enter Sleep Disorders',
              hintStyle: kHintTextStyle,
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "Sleep Disorders harus diisi";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            setState(() {
              _isLoading = true;
            });

            PemantauanTidur newPemantauanTidur = PemantauanTidur(
              sleepQuality: _sleepQualityTextboxController.text,
              sleepHours: int.parse(_sleepHoursTextboxController.text),
              sleepDisorders: _sleepDisordersTextboxController.text,
            );

            var response;

            if (widget.pemantauanTidur == null) {
              // Add new data
              response = await PemantauanTidurBloc.addPemantauanTidur(
                  pemantauanTidur: newPemantauanTidur);
            } else {
              // Update existing data
              newPemantauanTidur.id = widget.pemantauanTidur!.id;
              response = await PemantauanTidurBloc.updatePemantauanTidur(
                  pemantauanTidur: newPemantauanTidur);
            }

            setState(() {
              _isLoading = false;
            });

            if (response == true) {
              // Show success message and navigate back or refresh
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Data berhasil disimpan!')));
              Navigator.pop(context,
                  true); // Return true to trigger refresh on the previous page
            } else {
              // Show error message
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal menyimpan data!')));
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 243, 160, 5),
          padding: const EdgeInsets.all(15.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: Text(
          tombolSubmit,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 214, 102),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Helvetica',
          ),
        ),
      ),
    );
  }
}
