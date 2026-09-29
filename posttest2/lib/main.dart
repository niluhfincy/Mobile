import 'package:flutter/material.dart';

// Palet warna catShop (kucing belang 3)
const Color warnaUtama = Color(0xFFF28C38); // oranye hangat
const Color warnaLatar = Color(0xFFFFF8F0); // krem lembut
const Color warnaTeksUtama = Color(0xFF3E2723); // cokelat tua
const Color warnaTeksSekunder = Color(0xFFA1887F); // abu kecokelatan
const Color warnaAksen = Color(0xFFD84315); // cokelat kemerahan (harga)
const Color warnaGaris = Color(0xFFEFE3D8); // garis / border tipis
const Color warnaPlaceholder = Color(0xFFE0E0E0); // abu-abu placeholder gambar
const Color warnaIkonPlaceholder = Color(0xFFBDBDBD); // ikon di placeholder

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp: widget pembungkus utama aplikasi (mengatur tema & halaman awal)
    return MaterialApp(
      title: 'catShop',
      debugShowCheckedModeBanner: false, // hilangkan tulisan debug di pojok kanan atas
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: warnaUtama),
      ),
      home: const HomePage(),
    );
  }
}


// Fungsi fungsi bersama (dipake sama HomePage & CartPage)

// Container gambar bulat-sudut dengan fallback ikon kalau gambar gagal dimuat
Widget buildGambarProduk(String url, {double ukuran = 100}) {
  // Container: bingkai gambar dengan sudut membulat, clipBehavior supaya gambar ikut terpotong melengkung
  return Container(
    width: ukuran,
    height: ukuran,
    clipBehavior: Clip.antiAlias,
    decoration: BoxDecoration(
      color: warnaPlaceholder,
      borderRadius: BorderRadius.circular(12),
    ),
    // Image: menampilkan foto produk yang diambil dari internet
    child: Image.asset(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Icon: ikon cadangan kalau gambar gagal dimuat (misal tidak ada internet)
        return const Icon(Icons.pets, size: 32, color: warnaIkonPlaceholder);
      },
    ),
  );
}

// Header sapaan + ikon notifikasi, dipake di HomePage
Widget buildHeader() {
  // Row: sapaan di kiri, ikon notifikasi di kanan
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      // Column: menumpuk sapaan dan subjudul ke bawah
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

// Search bar, dipake di HomePage & CartPage
Widget buildSearchBar({String hint = 'Cari makanan, mainan, pasir...'}) {
  // TextField: kolom input untuk mencari produk
  return TextField(
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: warnaTeksSekunder),
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
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

// Bottom navigation, dipake di HomePage (aktifIndex 0) & CartPage (aktifIndex 1)
Widget buildBottomNav(BuildContext context, int aktifIndex) {
  // Container: latar putih dengan garis tipis di atas sebagai pemisah
  return Container(
    decoration: const BoxDecoration(
      color: Colors.white,
      border: Border(top: BorderSide(color: warnaGaris)),
    ),
    // SafeArea: agar tidak tertutup gesture bar / tombol navigasi HP
    child: SafeArea(
      // Padding: jarak atas-bawah bar navigasi
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        // Row: 3 menu navigasi berjejer ke samping
        child: Row(
          children: [
            // Expanded: tiap menu mendapat lebar yang sama rata
            Expanded(
              child: buildNavItem(
                context,
                icon: Icons.home,
                label: 'Beranda',
                index: 0,
                aktifIndex: aktifIndex,
              ),
            ),
            Expanded(
              child: buildNavItem(
                context,
                icon: Icons.shopping_cart,
                label: 'Keranjang',
                index: 1,
                aktifIndex: aktifIndex,
              ),
            ),
            Expanded(
              child: buildNavItem(
                context,
                icon: Icons.person,
                label: 'Profil',
                index: 2,
                aktifIndex: aktifIndex,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildNavItem(
    BuildContext context, {
      required IconData icon,
      required String label,
      required int index,
      required int aktifIndex,
    }) {
  final bool aktif = index == aktifIndex;

  // GestureDetector: mendeteksi ketukan pada menu navigasi agar Navigator bisa dipanggil
  return GestureDetector(
    onTap: () {
      if (index == aktifIndex) return; // sudah di halaman ini
      if (index == 1) {
        // Navigator.push: membuka CartPage baru di atas tumpukan navigasi
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CartPage()),
        );
      } else if (index == 0) {
        // Navigator.pop: kembali ke halaman sebelumnya (Beranda)
        Navigator.pop(context);
      }
    },
    // Column: ikon di atas, tulisan di bawah
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon: ikon menu (oranye kalau aktif, abu kecokelatan kalau tidak)
        Icon(icon, size: 24, color: aktif ? warnaUtama : warnaTeksSekunder),
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
    ),
  );
}


// Homepage
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: struktur dasar halaman (background, body, bottom navigation)
    return Scaffold(
      backgroundColor: warnaLatar,
      // SafeArea: memastikan konten tidak tertutup notch / status bar
      body: SafeArea(
        // SingleChildScrollView: membuat seluruh halaman bisa di-scroll
        child: SingleChildScrollView(
          // Padding: memberi jarak di sekeliling konten halaman
          child: Padding(
            padding: const EdgeInsets.all(16),
            // Column: menyusun semua bagian homepage dari atas ke bawah
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                // SizedBox: jarak vertikal antar bagian
                const SizedBox(height: 16),
                buildSearchBar(),
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
                  gambar:
                  'assets/gambar/food.jpg',
                  nama: 'Royal Canin Kitten 2kg',
                  deskripsi: 'Makanan kering untuk anak kucing',
                  harga: 'Rp185.000',
                ),
                _buildProductCard(
                  gambar:
                  'assets/gambar/toy.jpg',
                  nama: 'Tongkat Bulu Mainan',
                  deskripsi: 'Mainan interaktif, bikin kucing aktif',
                  harga: 'Rp25.000',
                ),
                _buildProductCard(
                  gambar:
                  'assets/gambar/litter.jpg',
                  nama: 'Pasir Gumpal Lavender 10L',
                  deskripsi: 'Menggumpal cepat, minim debu',
                  harga: 'Rp65.000',
                ),
                _buildProductCard(
                  gambar:
                  'assets/gambar/collar.jpg',
                  nama: 'Kalung Lonceng Kucing',
                  deskripsi: 'Bahan lembut dan nyaman dipakai',
                  harga: 'Rp30.000',
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: buildBottomNav(context, 0),
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

  // Banner promo (pake Image + Stack + Positioned)
  Widget _buildPromoBanner() {
    // Container: bingkai luar banner, sudut membulat, clip supaya foto ikut melengkung
    return Container(
      width: double.infinity,
      height: 150,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      // Stack: menumpuk foto latar, lapisan gelap, dan teks promo di area yang sama
      child: Stack(
        children: [
          // Positioned: menempatkan foto latar memenuhi seluruh area banner
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            // Image: foto kucing sebagai latar banner, diambil dari internet
            child: Image.asset(
              'assets/gambar/banner.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: warnaUtama);
              },
            ),
          ),
          // Positioned: lapisan gelap transparan supaya teks tetap terbaca di atas foto
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(color: Colors.black.withValues(alpha: 0.35)),
          ),
          // Positioned: menempatkan teks & tombol promo di sisi kiri-bawah banner
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
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
                const SizedBox(height: 10),
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
        ],
      ),
    );
  }

  // Kartu produk
  Widget _buildProductCard({
    required String gambar,
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
          buildGambarProduk(gambar),
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
}

// Cart page (halaman baru, dibuka pake Navigator.push dari bottom nav)

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold: struktur dasar halaman keranjang
    return Scaffold(
      backgroundColor: warnaLatar,
      // SafeArea: memastikan konten tidak tertutup notch / status bar
      body: SafeArea(
        // Stack: menumpuk daftar produk keranjang dengan bar total yang mengambang di bawah
        child: Stack(
          children: [
            // SingleChildScrollView: daftar produk keranjang bisa di-scroll
            SingleChildScrollView(
              // Padding: jarak halaman, bagian bawah dilebihkan supaya tidak ketutup bar total
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                // Column: menyusun judul dan daftar item keranjang ke bawah
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text: judul halaman
                    const Text(
                      'Keranjang Saya',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: warnaTeksUtama,
                      ),
                    ),
                    const SizedBox(height: 16),
                    buildSearchBar(hint: 'Cari di keranjang...'),
                    const SizedBox(height: 20),
                    _buildCartItem(
                      gambar:
                      'assets/gambar/food.jpg',
                      nama: 'Royal Canin Kitten 2kg',
                      deskripsi: 'Makanan kering untuk anak kucing',
                      harga: 'Rp185.000',
                    ),
                    _buildCartItem(
                      gambar:
                      'assets/gambar/litter.jpg',
                      nama: 'Pasir Gumpal Lavender 10L',
                      deskripsi: 'Menggumpal cepat, minim debu',
                      harga: 'Rp65.000',
                    ),
                  ],
                ),
              ),
            ),
            // Positioned: menempatkan bar total di bagian bawah layar, menumpuk di atas daftar produk
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildTotalBar(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNav(context, 1),
    );
  }

  // Item keranjang
  Widget _buildCartItem({
    required String gambar,
    required String nama,
    required String deskripsi,
    required String harga,
  }) {
    // Container: kartu putih pembungkus satu item keranjang
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: warnaGaris),
      ),
      // Row: gambar, info produk, dan input jumlah berjejer ke samping
      child: Row(
        children: [
          buildGambarProduk(gambar, ukuran: 70),
          // SizedBox: jarak antara gambar dan info produk
          const SizedBox(width: 12),
          // Expanded: info produk mengisi sisa ruang
          Expanded(
            // Column: menumpuk nama, deskripsi, dan harga
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text: nama produk
                Text(
                  nama,
                  style: const TextStyle(
                    fontSize: 13,
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
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: warnaAksen,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox: jarak sebelum kolom jumlah
          const SizedBox(width: 8),
          // SizedBox: membatasi lebar kolom input jumlah
          SizedBox(
            width: 48,
            // TextField: input jumlah produk, hanya menerima angka
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '1',
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: warnaGaris),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Bar total (pake BoxShadow)
  Widget _buildTotalBar() {
    // Container: kotak putih berisi total harga dan tombol checkout
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        // BoxShadow: bayangan tipis di atas bar supaya terlihat mengambang di atas daftar produk
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      // Row: info total di kiri, tombol checkout di kanan
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Column: menumpuk label dan nilai total
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              // Text: label total
              Text(
                'Total',
                style: TextStyle(fontSize: 12, color: warnaTeksSekunder),
              ),
              // Text: nilai total
              Text(
                'Rp250.000',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: warnaAksen,
                ),
              ),
            ],
          ),
          // Container: tombol "Checkout"
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: warnaUtama,
              borderRadius: BorderRadius.circular(10),
            ),
            // Row: ikon dan tulisan pada tombol checkout
            child: const Row(
              children: [
                // Icon: ikon keranjang belanja
                Icon(Icons.shopping_cart, size: 16, color: Colors.white),
                SizedBox(width: 6),
                // Text: tulisan tombol
                Text('Checkout', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}