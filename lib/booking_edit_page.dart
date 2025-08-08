import 'package:flutter/material.dart';

class EditBookingPage extends StatefulWidget {
  final String? title;
  final String? price;
  final String? rating;
  final String? imageUrl;

  const EditBookingPage({
    super.key,
    this.title,
    this.price,
    this.rating,
    this.imageUrl,
  });

  @override
  State<EditBookingPage> createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dailyRateController = TextEditingController();
  final _weeklyRateController = TextEditingController();
  final _monthlyRateController = TextEditingController();

  String? _selectedCategory = 'Electronics';
  final List<String> _selectedImages = [];

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

  @override
  void initState() {
    super.initState();
    // Pre-fill form with existing data
    _titleController.text = 'Electrical Box';
    _descriptionController.text =
        'Electrical Box\nVintage model 23\nOnly used 6 months';
    _dailyRateController.text = '0';
    _weeklyRateController.text = '0';
    _monthlyRateController.text = '0';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _dailyRateController.dispose();
    _weeklyRateController.dispose();
    _monthlyRateController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
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

  void _updateListing() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Listing updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Listing',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Selection
              _buildSectionLabel('Category'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
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
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item title';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Item Description
              _buildSectionLabel('Item Description'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    // Rich Text Toolbar
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
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
                    // Text Area
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter item description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Pricing Section
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

              // Pick Images Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionLabel('Pick Images'),
                  TextButton.icon(
                    onPressed: _pickImages,
                    icon: const Icon(Icons.upload, size: 18),
                    label: const Text('Upload Images'),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue[50],
                      foregroundColor: Colors.blue[700],
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Images Display
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: _selectedImages.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
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
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey,
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
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
              ),

              const SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateListing,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Update Listing',
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, VoidCallback onPressed) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: Colors.grey[600]),
      padding: const EdgeInsets.all(4),
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
    );
  }
}

// Updated ListingEditPage with navigation to EditListingPage
class ListingEditPage extends StatelessWidget {
  const ListingEditPage({super.key});

  final List<Map<String, String>> listings = const [
    {
      "image":
          "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=800&q=80",
      "title": "Bed Apartment",
      "price": "\$ 0/Day",
      "rating": "★★★★☆",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=800&q=80",
      "title": "Luxury Villa",
      "price": "\$ 10/Day",
      "rating": "★★★☆☆",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1600585154172-3b5f3c6ae3ea?auto=format&fit=crop&w=800&q=80",
      "title": "Family House",
      "price": "\$ 5/Day",
      "rating": "★★★★★",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1572120360610-d971b9b78836?auto=format&fit=crop&w=800&q=80",
      "title": "Studio Flat",
      "price": "\$ 0/Day",
      "rating": "★★☆☆☆",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1615874959474-d609969a6a84?auto=format&fit=crop&w=800&q=80",
      "title": "Modern Condo",
      "price": "\$ 12/Day",
      "rating": "★★★☆☆",
    },
    {
      "image":
          "https://images.unsplash.com/photo-1600585153943-24d048c1a9a0?auto=format&fit=crop&w=800&q=80",
      "title": "Beachfront Home",
      "price": "\$ 0/Day",
      "rating": "★★★☆☆",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        leading: const Icon(Icons.arrow_back, size: 20, color: Colors.black),
        title: const Text(
          "My Listing",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: 'Search Listings...',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.77,
                children: listings.map((listing) {
                  return ListingBox(
                    image: listing["image"]!,
                    title: listing["title"]!,
                    price: listing["price"]!,
                    rating: listing["rating"]!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.cyan[700],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddNewListingPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class ListingBox extends StatelessWidget {
  final String image;
  final String title;
  final String price;
  final String rating;

  const ListingBox({
    super.key,
    required this.image,
    required this.title,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    image,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Row(
                    children: [
                      _iconCircle(Icons.edit, Colors.cyan, () {
                        // Navigator.push(
                        // context,
                        // MaterialPageRoute(
                        //   builder: (context) => EditListingPage(
                        //     title: title,
                        //     price: price,
                        //     rating: rating,
                        //     imageUrl: image,
                        //   ),
                        // ),
                        // );
                      }),
                      const SizedBox(width: 5),
                      _iconCircle(Icons.delete, Colors.red, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Delete tapped")),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    price,
                    style: const TextStyle(color: Colors.orange, fontSize: 12),
                  ),
                  Text(rating, style: const TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconCircle(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: Icon(icon, size: 14, color: color),
      ),
    );
  }
}

// Placeholder for AddNewListingPage import
class AddNewListingPage extends StatelessWidget {
  const AddNewListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Listing'),
        backgroundColor: Colors.cyan,
      ),
      body: const Center(child: Text('Add New Listing Page')),
    );
  }
}
