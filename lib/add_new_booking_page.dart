import 'package:flutter/material.dart';

class AddNewBookingPage extends StatefulWidget {
  const AddNewBookingPage({super.key});

  @override
  _AddNewBookingPageState createState() => _AddNewBookingPageState();
}

class _AddNewBookingPageState extends State<AddNewBookingPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dailyRateController = TextEditingController();
  final TextEditingController _weeklyRateController = TextEditingController();
  final TextEditingController _monthlyRateController = TextEditingController();

  String _selectedCategory = 'Electronics';
  final List<String> _categories = [
    'Electronics',
    'Furniture',
    'Vehicles',
    'Tools & Equipment',
    'Sports & Recreation',
    'Clothing & Accessories',
    'Books & Media',
    'Home & Garden',
    'Musical Instruments',
    'Other',
  ];

  final List<String> _selectedImages = [];

  Future<void> _pickImages() async {
    // Demo: Adding placeholder image paths
    setState(() {
      _selectedImages.add(
        'assets/images/sample${_selectedImages.length + 1}.jpg',
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image added! (Demo mode)'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _addBooking() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('New booking added successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context);
    }
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(fontSize: 15, color: Colors.black87),
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, VoidCallback onPressed) {
    // Optional formatting buttons, non-functional demo only
    return IconButton(
      icon: Icon(icon, color: Colors.grey.shade600, size: 18),
      onPressed: onPressed,
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'Add New Booking',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black87),
        elevation: 1,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category
              _buildSectionLabel('Category'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  items: _categories
                      .map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      if (value != null) _selectedCategory = value;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Item Title
              _buildSectionLabel('Item Title'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _titleController,
                hint: 'Enter item title',
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Please enter item title' : null,
              ),

              const SizedBox(height: 20),

              // Item Description with toolbar
              _buildSectionLabel('Item Description'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const Text(
                              'Paragraph',
                              style: TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            _buildToolbarButton(Icons.format_bold, () {}),
                            _buildToolbarButton(Icons.format_italic, () {}),
                            _buildToolbarButton(Icons.link, () {}),
                            _buildToolbarButton(
                              Icons.format_list_bulleted,
                              () {},
                            ),
                            _buildToolbarButton(
                              Icons.format_list_numbered,
                              () {},
                            ),
                            _buildToolbarButton(
                              Icons.format_indent_increase,
                              () {},
                            ),
                            _buildToolbarButton(
                              Icons.format_indent_decrease,
                              () {},
                            ),
                            _buildToolbarButton(Icons.image, () {}),
                            _buildToolbarButton(Icons.format_quote, () {}),
                          ],
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 6,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Please enter item description'
                          : null,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Pricing rates
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('Daily Rate'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _dailyRateController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('Weekly Rate'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _weeklyRateController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('Monthly Rate'),
                        const SizedBox(height: 8),
                        _buildTextField(
                          controller: _monthlyRateController,
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Images section with upload button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionLabel('Pick Images'),
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.upload, size: 18),
                    label: const Text('Upload Images'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Images preview or "No Images" message
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: _selectedImages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'No Images',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(8),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                        itemCount: _selectedImages.length,
                        itemBuilder: (context, index) => Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.image,
                                  color: Colors.grey.shade600,
                                  size: 24,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: GestureDetector(
                                onTap: () => _removeImage(index),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              const SizedBox(height: 30),

              // Add booking button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Booking',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
