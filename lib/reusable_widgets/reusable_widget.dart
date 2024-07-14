import 'package:flutter/material.dart';

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.pinkAccent,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.red,
    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.pinkAccent,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: 16),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.pink.shade50.withOpacity(0.9),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 1.0, color: Colors.pinkAccent, style: BorderStyle.solid),
      ),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

DropdownButtonFormField<String> reusableDropdown(
    List<String> items, String? selectedValue, String hintText, Function(String?) onChanged) {
  return DropdownButtonFormField<String>(
    value: selectedValue,
    items: items.map((String item) {
      return DropdownMenuItem<String>(
        value: item,
        child: Text(item),
      );
    }).toList(),
    onChanged: (value) {
      onChanged(value);
    },
    decoration: InputDecoration(
      labelText: selectedValue == null ? hintText : "Select Options",
      labelStyle: TextStyle(color: Colors.black.withOpacity(0.3)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.pink.shade50.withOpacity(0.9),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30.0),
        borderSide: const BorderSide(width: 1.0, color: Colors.green, style: BorderStyle.solid),
      ),
    ),
    dropdownColor: Colors.white,
    style: TextStyle(color: Colors.black.withOpacity(0.9), fontWeight: FontWeight.bold, fontSize: 16), // Text color inside dropdown
  );
}


// New Coding for the questionnaires box
class ReusableDropdown extends StatelessWidget {
  final String question;
  final String hintText;
  final List<String> options;
  final Function(String?) onChanged;

  ReusableDropdown({
    required this.question,
    required this.hintText,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)) ,
            filled: true,
            // floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.limeAccent.withOpacity(0.6),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(width: 2.0, color: Colors.black, style: BorderStyle.none),
            ),
          ),
          items: options.map((String option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.60, // Ensures the dropdown text fits within the screen width
                child: Text(
                  option,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.visible, // Ensures text wraps to the next line
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        SizedBox(height: 16),
      ],
    );
  }
}

class ReusableTextField extends StatelessWidget {
  final String question;
  final String hintText;
  final FormFieldSetter<String> onSaved;

  ReusableTextField({
    required this.question,
    required this.hintText,
    required this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextFormField(
          decoration: InputDecoration(
              labelText: hintText,
              labelStyle: TextStyle(color: Colors.black.withOpacity(0.8)) ,
              filled: true,
              fillColor: Colors.limeAccent.withOpacity(0.6),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter a value';
            }
            return null;
          },
          onSaved: onSaved,
        ),
        SizedBox(height: 20),
      ],
    );
  }
}

