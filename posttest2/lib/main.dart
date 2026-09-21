import 'package:flutter/material.dart';

// Palet warna catShop (kucing belang 3)
const Color warnaUtama = Color(0xFFF28C38); // orange
const Color warnaLatar = Color(0xFFFFF8F0); // krem
const Color warnaTeksUtama = Color(0xFF3E2723); // coklat tua
const Color warnaTeksSekunder = Color(0xFFA1887F); // abu kecoklatan
const Color warnaAksen = Color(0xFFD84315); // coklat kemerahan (harga)
const Color warnaGaris = Color(0xFFEFE3D8); // garis / border tipis
const Color warnaPlaceholder = Color(0xFFE0E0E0); // abu abu untuk placeholder gambar
const Color warnaIkonPlaceholder = Color(0xFFBDBDBD); // ikon di placeholder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: widget pembungkus utama aplikasi (buat ngatur tema & halaman awal)
    return MaterialApp(
      title: 'catShop',
      debugShowCheckedModeBanner: false, // ngilangin tulisan debug di pojok kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: warnaUtama),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: struktur dasar halaman (background, body, bottom navigation)
    return Scaffold(
      backgroundColor: warnaLatar,
      // SafeArea: buat mastiin konten tidak tertutup notch / status bar
      body: SafeArea(
        // SingleChildScrollView: ngebuat semua halaman bisa di scroll
        child: SingleChildScrollView(
          // Padding: ngasih jarak di sekeliling konten halaman
          child: Padding(
            padding: const EdgeInsets.all(16),
            // Column: nyusun semua bagian homepage dari atas ke bawah
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                // SizedBox: jarak vertikal antar bagian
                const SizedBox(height: 16),
                _buildSearchBar(),
                const SizedBox(height: 24),
                _buildCategories(),
                const SizedBox(height: 24),
                _buildPromoBanner(),
                const SizedBox(height: 24),
                // Text: judul bagian produk
                const Text(
                  'Produk Populer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: warnaTeksUtama,
                  ),
                ),
                const SizedBox(height: 12),
                _buildProductCard(
                  nama: 'Royal Canin Kitten 2kg',
                  deskripsi: 'Makanan kering untuk anak kucing',
                  harga: 'Rp185.000',
                ),
                _buildProductCard(
                  nama: 'Tongkat Bulu Mainan',
                  deskripsi: 'Mainan interaktif, bikin kucing aktif',
                  harga: 'Rp25.000',
                ),
                _buildProductCard(
                  nama: 'Pasir Gumpal Lavender 10L',
                  deskripsi: 'Menggumpal cepat, minim debu',
                  harga: 'Rp65.000',
                ),
                _buildProductCard(
                  nama: 'Kalung Lonceng Kucing',
                  deskripsi: 'Bahan lembut dan nyaman dipakai',
                  harga: 'Rp30.000',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // HEADER: sapaan + ikon notifikasi
  Widget _buildHeader() {
    // Row: sapaan di kiri, ikon notifikasi di kanan
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Column: numpuk sapaan dan subjudul ke bawah
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            // Text: sapaan utama
            Text(
              'Halo, Pecinta Kucing!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: warnaTeksUtama,
              ),
            ),
            SizedBox(height: 4),
            // Text: subjudul
            Text(
              'Mau belanja apa hari ini?',
              style: TextStyle(fontSize: 13, color: warnaTeksSekunder),
            ),
          ],
        ),
        // Container: kotak bulat pembungkus ikon notifikasi
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: warnaGaris),
          ),
          // Icon: ikon notifikasi
          child: const Icon(
            Icons.notifications_none,
            size: 24,
            color: warnaUtama,
          ),
        ),
      ],
    );
  }

  // Search Bar
  Widget _buildSearchBar() {
    // TextField: kolom input untuk mencari produk
    return TextField(
      decoration: InputDecoration(
        hintText: 'Cari makanan, mainan, pasir...',
        hintStyle: const TextStyle(color: warnaTeksSekunder),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        // Padding: memberi jarak ikon search dari tepi kanan
        suffixIcon: const Padding(
          padding: EdgeInsets.only(right: 16),
          // Icon: ikon search di ujung kanan TextField
          child: Icon(Icons.search, size: 24, color: warnaTeksSekunder),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: warnaGaris),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: warnaGaris),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: warnaUtama),
        ),
      ),
    );
  }

  // Kategori
  Widget _buildCategories() {
    // Row: 4 kategori berjejer ke samping dengan jarak rata
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCategoryItem(Icons.restaurant, 'Makanan'),
        _buildCategoryItem(Icons.toys, 'Mainan'),
        _buildCategoryItem(Icons.cleaning_services, 'Pasir'),
        _buildCategoryItem(Icons.checkroom, 'Aksesoris'),
      ],
    );
  }

  Widget _buildCategoryItem(IconData icon, String label) {
    // Column: ikon di atas, nama kategori di bawah
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Container: kotak putih berisi ikon kategori
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: warnaGaris),
          ),
          // Icon: ikon kategori
          child: Icon(icon, size: 28, color: warnaUtama),
        ),
        // SizedBox: jarak antara kotak dan label
        const SizedBox(height: 8),
        // Text: nama kategori
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: warnaTeksUtama),
        ),
      ],
    );
  }

  // Banner Promo
  Widget _buildPromoBanner() {
    // Container: kotak besar orange buat banner promo
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: warnaUtama,
        borderRadius: BorderRadius.circular(20),
      ),
      // Row: teks promo di kiri, ikon di kanan
      child: Row(
        children: [
          // Expanded: teks promo mengisi sisa ruang di samping ikon
          Expanded(
            // Column: menumpuk teks promo ke bawah
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: label promo
                const Text(
                  'PROMO MINGGU INI',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                // Text: judul promo
                const Text(
                  'Diskon 20% Royal Canin',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Text: keterangan promo
                const Text(
                  'Untuk semua varian makanan kucing',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
                const SizedBox(height: 12),
                // Container: tombol "Belanja Sekarang" berbentuk pil putih
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // Text: tulisan pada tombol
                  child: const Text(
                    'Belanja Sekarang',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: warnaUtama,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox: jarak antara teks dan ikon
          const SizedBox(width: 12),
          // Icon: ikon kaki kucing sebagai hiasan banner
          const Icon(Icons.pets, size: 64, color: Colors.white),
        ],
      ),
    );
  }

  // ===== KARTU PRODUK =====
  Widget _buildProductCard({
    required String nama,
    required String deskripsi,
    required String harga,
  }) {
    // Container: kartu putih pembungkus satu produk
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: warnaGaris),
      ),
      // Row: gambar di kiri, info produk di kanan
      child: Row(
        children: [
          // Container: placeholder gambar produk (abu-abu)
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: warnaPlaceholder,
              borderRadius: BorderRadius.circular(12),
            ),
            // Icon: ikon kaki kucing di tengah placeholder
            child: const Icon(Icons.pets, size: 40, color: warnaIkonPlaceholder),
          ),
          // SizedBox: jarak antara gambar dan info produk
          const SizedBox(width: 12),
          // Expanded: info produk mengisi sisa ruang di samping gambar
          Expanded(
            // Column: menumpuk nama, deskripsi, harga, dan tombol
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama produk
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: warnaTeksUtama,
                  ),
                ),
                const SizedBox(height: 2),
                // Text: deskripsi singkat
                Text(
                  deskripsi,
                  style: const TextStyle(
                    fontSize: 11,
                    color: warnaTeksSekunder,
                  ),
                ),
                const SizedBox(height: 4),
                // Text: harga produk
                Text(
                  harga,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: warnaAksen,
                  ),
                ),
                const SizedBox(height: 8),
                // Container: tombol "Masukkan Keranjang"
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: warnaUtama,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // Row: ikon keranjang + tulisan, diposisikan di tengah
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon: ikon keranjang belanja
                      Icon(Icons.shopping_cart, size: 14, color: Colors.white),
                      SizedBox(width: 6),
                      // Text: tulisan tombol
                      Text(
                        'Masukkan Keranjang',
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigasi Bawah
  Widget _buildBottomNav() {
    // Container: latar putih dengan garis tipis di atas sebagai pemisah
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: warnaGaris)),
      ),
      // SafeArea: agar tidak tertutup gesture bar / tombol navigasi HP
      child: SafeArea(
        // Padding: jarak atas bawah bar navigasi
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          // Row: 3 menu navigasi berjejer ke samping
          child: Row(
            children: [
              // Expanded: tiap menu mendapat lebar yang sama rata
              Expanded(child: _buildNavItem(Icons.home, 'Beranda', true)),
              Expanded(
                child: _buildNavItem(Icons.shopping_cart, 'Keranjang', false),
              ),
              Expanded(child: _buildNavItem(Icons.person, 'Profil', false)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool aktif) {
    // Column: ikon di atas, tulisan di bawah
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon: ikon menu (orange kalau aktif, abu kecoklatan kalau tidak)
        Icon(
          icon,
          size: 24,
          color: aktif ? warnaUtama : warnaTeksSekunder,
        ),
        // SizedBox: jarak antara ikon dan tulisan
        const SizedBox(height: 4),
        // Text: nama menu
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
            color: aktif ? warnaUtama : warnaTeksSekunder,
          ),
        ),
      ],
    );
  }
}