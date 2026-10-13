import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Palet warna catShop (kucing belang 3)
const Color warnaUtama = Color(0xFFF28C38); // oranye hangat
const Color warnaLatar = Color(0xFFFFF8F0); // krem lembut
const Color warnaTeksUtama = Color(0xFF3E2723); // cokelat tua
const Color warnaTeksSekunder = Color(0xFFA1887F); // abu kecokelatan
const Color warnaAksen = Color(0xFFD84315); // cokelat kemerahan (harga)
const Color warnaGaris = Color(0xFFEFE3D8); // garis / border tipis
const Color warnaPlaceholder = Color(0xFFE0E0E0); // abu-abu placeholder gambar
const Color warnaIkonPlaceholder = Color(0xFFBDBDBD); // ikon di placeholder
const Color warnaNonaktif = Color(0xFFD7D7D7); // abu tombol/elemen yang dimatikan

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ChangeNotifierProvider: menyediakan satu CartProvider ke seluruh aplikasi. Semua halaman di bawah ini (Home, Cart) bisa membaca dan mengubah data yang sama lewat provider ini.
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      // MaterialApp: widget pembungkus utama aplikasi (mengatur tema & halaman awal)
      child: MaterialApp(
        title: 'catShop',
        debugShowCheckedModeBanner: false, // hilangkan tulisan debug di pojok kanan atas
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: warnaUtama),
        ),
        home: const HomePage(),
      ),
    );
  }
}

// Data Produk
class Produk {
  final String id;
  final String nama;
  final String deskripsi;
  final String gambar;
  final int harga;
  int stok; // berubah ubah, dimutasi lewat method di CartProvider

  Produk({
    required this.id,
    required this.nama,
    required this.deskripsi,
    required this.gambar,
    required this.harga,
    required this.stok,
  });
}

// Format angka jadi "Rp185.000"
String formatRupiah(int angka) {
  final teks = angka.toString();
  final buffer = StringBuffer();
  for (int i = 0; i < teks.length; i++) {
    final posisiDariKanan = teks.length - i;
    buffer.write(teks[i]);
    if (posisiDariKanan > 1 && posisiDariKanan % 3 == 1) {
      buffer.write('.');
    }
  }
  return 'Rp$buffer';
}

// CART PROVIDER — "papan tulis" bersama yang dibaca dan diubah oleh HomePage dan CartPage. extends ChangeNotifier: menjadikan
// class ini bisa "diamati" oleh widget lain lewat Provider.
class CartProvider extends ChangeNotifier {
  // Daftar produk toko, dulunya tersebar lewat setState di tiap halaman, sekarang jadi satu sumber data yang dipakai bersama
  final List<Produk> daftarProduk = [
    Produk(
      id: 'food',
      nama: 'Royal Canin Kitten 2kg',
      deskripsi: 'Makanan kering untuk anak kucing',
      gambar: 'assets/gambar/food.jpg',
      harga: 185000,
      stok: 5,
    ),
    Produk(
      id: 'toy',
      nama: 'Tongkat Bulu Mainan',
      deskripsi: 'Mainan interaktif, bikin kucing aktif',
      gambar: 'assets/gambar/toy.jpg',
      harga: 25000,
      stok: 8,
    ),
    Produk(
      id: 'litter',
      nama: 'Pasir Gumpal Lavender 10L',
      deskripsi: 'Menggumpal cepat, minim debu',
      gambar: 'assets/gambar/litter.jpg',
      harga: 65000,
      stok: 3,
    ),
    Produk(
      id: 'collar',
      nama: 'Kalung Lonceng Kucing',
      deskripsi: 'Bahan lembut dan nyaman dipakai',
      gambar: 'assets/gambar/collar.jpg',
      harga: 30000,
      stok: 6,
    ),
  ];

  // Isi keranjang: key = id produk, value = jumlah yang dimasukkan ke keranjang
  final Map<String, int> keranjang = {};

  // Produk yang sedang ada di keranjang (jumlahnya lebih dari 0)
  List<Produk> get itemKeranjang =>
      daftarProduk.where((p) => (keranjang[p.id] ?? 0) > 0).toList();

  // Total harga seluruh isi keranjang
  int get totalHarga {
    int total = 0;
    for (final produk in daftarProduk) {
      final jumlah = keranjang[produk.id] ?? 0;
      total += produk.harga * jumlah;
    }
    return total;
  }

  // Menambahkan satu produk ke keranjang (kalau stok masih ada)
  void tambahKeKeranjang(Produk produk) {
    if (produk.stok > 0) {
      produk.stok -= 1;
      keranjang[produk.id] = (keranjang[produk.id] ?? 0) + 1;
      // notifyListeners: memberi tahu semua widget yang "mendengarkan"
      // provider ini bahwa datanya berubah, supaya mereka membangun ulang UI
      notifyListeners();
    }
  }

  // Mengurangi 1 jumlah produk di keranjang (stok dikembalikan)
  void kurangiJumlah(Produk produk) {
    final jumlahSekarang = keranjang[produk.id] ?? 0;
    if (jumlahSekarang > 0) {
      produk.stok += 1;
      final jumlahBaru = jumlahSekarang - 1;
      if (jumlahBaru == 0) {
        keranjang.remove(produk.id);
      } else {
        keranjang[produk.id] = jumlahBaru;
      }
      notifyListeners();
    }
  }

  // Menghapus produk sepenuhnya dari keranjang (stok dikembalikan semua)
  void hapusDariKeranjang(Produk produk) {
    final jumlah = keranjang[produk.id] ?? 0;
    produk.stok += jumlah;
    keranjang.remove(produk.id);
    notifyListeners();
  }

  // Checkout: mengosongkan keranjang
  void checkout() {
    keranjang.clear();
    notifyListeners();
  }
}

// Fungsi fungsi tampilan bersama (dipakai oleh HomePage & CartPage)

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
    // Image: menampilkan foto produk yang diambil dari file lokal di assets/gambar
    child: Image.asset(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Icon: ikon cadangan kalau gambar gagal dimuat
        return const Icon(Icons.pets, size: 32, color: warnaIkonPlaceholder);
      },
    ),
  );
}

// Header sapaan + ikon notifikasi, dipakai di HomePage
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

// Search bar, dipakai di HomePage (aktif memfilter) & CartPage (tampilan saja)
Widget buildSearchBar({
  String hint = 'Cari makanan, mainan, pasir...',
  TextEditingController? controller,
  ValueChanged<String>? onChanged,
}) {
  // TextField: kolom input untuk mencari produk
  return TextField(
    controller: controller,
    onChanged: onChanged,
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

// Bottom navigation, dipakai di HomePage (aktifIndex 0) & CartPage (aktifIndex 1)
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
      // index 2 (Profil) sengaja belum diisi navigasi, konsisten dari PT2
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

// Homepage — stok & keranjang dibaca/diubah lewat CartProvider

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // TextEditingController: menyimpan & mengontrol teks pada search bar
  final TextEditingController _searchController = TextEditingController();
  // State lokal: kata kunci pencarian yang sedang diketik, dipakai untuk filter
  String _kataKunci = '';

  @override
  void dispose() {
    // dispose: dijalankan saat HomePage dihapus dari tampilan, controller
    // harus dibersihkan di sini supaya tidak membebani memori
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch: "berlangganan" ke CartProvider, supaya HomePage
    // membangun ulang tampilannya setiap kali data di provider berubah
    // (misal stok berkurang karena ditambah/dikurangi dari CartPage)
    final cart = context.watch<CartProvider>();

    // Daftar produk yang sudah disaring sesuai kata kunci pencarian
    final produkTersaring = cart.daftarProduk
        .where((p) => p.nama.toLowerCase().contains(_kataKunci.toLowerCase()))
        .toList();

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
                buildSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    // setState: kata kunci pencarian ini murni state lokal
                    // halaman (bukan data bersama), jadi cukup setState biasa
                    setState(() {
                      _kataKunci = value;
                    });
                  },
                ),
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
                // Jika hasil pencarian kosong, tampilkan pesan. Kalau tidak,
                // tampilkan kartu untuk setiap produk yang tersaring
                if (produkTersaring.isEmpty)
                // Text: pesan saat produk tidak ditemukan
                  const Text(
                    'Produk tidak ditemukan.',
                    style: TextStyle(color: warnaTeksSekunder),
                  )
                else
                // Column: menumpuk kartu-kartu produk hasil pencarian
                  Column(
                    children: produkTersaring
                        .map((produk) => _buildProductCard(context, produk))
                        .toList(),
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

  // Banner Promo (pakai Image + Stack + Positioned)
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
            child: Image.network(
              'https://placehold.co/800x400/F28C38/FFFFFF?text=Cat+Banner',
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
  Widget _buildProductCard(BuildContext context, Produk produk) {
    final bool habis = produk.stok <= 0;

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
          buildGambarProduk(produk.gambar),
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
                  produk.nama,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: warnaTeksUtama,
                  ),
                ),
                const SizedBox(height: 2),
                // Text: deskripsi singkat
                Text(
                  produk.deskripsi,
                  style: const TextStyle(
                    fontSize: 11,
                    color: warnaTeksSekunder,
                  ),
                ),
                const SizedBox(height: 4),
                // Text: harga produk + sisa stok
                Text(
                  '${formatRupiah(produk.harga)} · Stok: ${produk.stok}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: warnaAksen,
                  ),
                ),
                const SizedBox(height: 8),
                // GestureDetector: mendeteksi ketukan tombol "Masukkan Keranjang".
                // onTap diisi null saat stok habis, otomatis membuat tombol tidak bisa ditekan
                GestureDetector(
                  onTap: habis
                      ? null
                  // context.read: mengambil CartProvider sekali untuk
                  // memanggil method-nya, TANPA ikut berlangganan
                  // perubahan (beda dengan context.watch di atas).
                  // Dipakai di dalam fungsi seperti onTap, bukan di build.
                      : () => context.read<CartProvider>().tambahKeKeranjang(produk),
                  // Container: tombol "Masukkan Keranjang" / "Stok Habis"
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: habis ? warnaNonaktif : warnaUtama,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    // Row: ikon keranjang + tulisan, diposisikan di tengah
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon: ikon keranjang belanja
                        Icon(
                          habis ? Icons.block : Icons.shopping_cart,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6),
                        // Text: tulisan tombol, berubah sesuai status stok
                        Text(
                          habis ? 'Stok Habis' : 'Masukkan Keranjang',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      ],
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
}

// Cart page

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch: berlangganan ke CartProvider supaya CartPage ikut
    // membangun ulang tampilannya setiap kali isi keranjang berubah
    final cart = context.watch<CartProvider>();
    final itemKeranjang = cart.itemKeranjang;

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
                    // Kalau keranjang kosong, tampilkan pesan. Kalau tidak,
                    // tampilkan satu kartu untuk setiap produk di keranjang
                    if (itemKeranjang.isEmpty)
                    // Text: pesan saat keranjang masih kosong
                      const Text(
                        'Keranjang masih kosong. Yuk belanja dulu di Beranda!',
                        style: TextStyle(color: warnaTeksSekunder),
                      )
                    else
                    // Column: menumpuk kartu-kartu item keranjang
                      Column(
                        children: itemKeranjang
                            .map((produk) => _buildCartItem(context, cart, produk))
                            .toList(),
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
              child: _buildTotalBar(
                context,
                cart.totalHarga,
                itemKeranjang.isNotEmpty,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNav(context, 1),
    );
  }

  // Item keranjang
  Widget _buildCartItem(BuildContext context, CartProvider cart, Produk produk) {
    final jumlah = cart.keranjang[produk.id] ?? 0;
    final bool stokHabis = produk.stok <= 0;

    // Container: kartu putih pembungkus satu item keranjang
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: warnaGaris),
      ),
      // Row: gambar, info produk, dan kontrol jumlah berjejer ke samping
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildGambarProduk(produk.gambar, ukuran: 70),
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
                  produk.nama,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: warnaTeksUtama,
                  ),
                ),
                const SizedBox(height: 2),
                // Text: deskripsi singkat
                Text(
                  produk.deskripsi,
                  style: const TextStyle(
                    fontSize: 11,
                    color: warnaTeksSekunder,
                  ),
                ),
                const SizedBox(height: 4),
                // Text: harga satuan produk
                Text(
                  formatRupiah(produk.harga),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: warnaAksen,
                  ),
                ),
              ],
            ),
          ),
          // SizedBox: jarak sebelum kolom kontrol jumlah
          const SizedBox(width: 8),
          // Column: ikon hapus di atas, kontrol jumlah di bawah
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // GestureDetector: mendeteksi ketukan ikon hapus item
              GestureDetector(
                onTap: () => context.read<CartProvider>().hapusDariKeranjang(produk),
                // Icon: ikon hapus item dari keranjang
                child: const Icon(
                  Icons.close,
                  size: 18,
                  color: warnaTeksSekunder,
                ),
              ),
              const SizedBox(height: 8),
              // Row: tombol kurang, jumlah, dan tombol tambah berjejer
              Row(
                children: [
                  // GestureDetector: mendeteksi ketukan tombol kurang jumlah
                  GestureDetector(
                    onTap: () => context.read<CartProvider>().kurangiJumlah(produk),
                    // Container: tombol bulat kecil untuk mengurangi jumlah
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: warnaLatar,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: warnaGaris),
                      ),
                      // Icon: ikon minus
                      child: const Icon(Icons.remove, size: 14),
                    ),
                  ),
                  // SizedBox: jarak sebelum angka jumlah
                  const SizedBox(width: 8),
                  // Text: jumlah produk saat ini di keranjang
                  Text(
                    '$jumlah',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: warnaTeksUtama,
                    ),
                  ),
                  // SizedBox: jarak sebelum tombol tambah
                  const SizedBox(width: 8),
                  // GestureDetector: mendeteksi ketukan tombol tambah jumlah,
                  // dimatikan (onTap: null) kalau stok produk sudah habis
                  GestureDetector(
                    onTap: stokHabis
                        ? null
                        : () => context.read<CartProvider>().tambahKeKeranjang(produk),
                    // Container: tombol bulat kecil untuk menambah jumlah
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: stokHabis ? warnaNonaktif : warnaUtama,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      // Icon: ikon plus
                      child: const Icon(
                        Icons.add,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Bar total (pakai boxshadow)
  Widget _buildTotalBar(BuildContext context, int totalHarga, bool adaItem) {
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
            children: [
              // Text: label total
              const Text(
                'Total',
                style: TextStyle(fontSize: 12, color: warnaTeksSekunder),
              ),
              // Text: nilai total, dihitung ulang setiap kali keranjang berubah
              Text(
                formatRupiah(totalHarga),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: warnaAksen,
                ),
              ),
            ],
          ),
          // GestureDetector: mendeteksi ketukan tombol checkout, dimatikan
          // kalau keranjang masih kosong
          GestureDetector(
            onTap: adaItem
                ? () {
              context.read<CartProvider>().checkout();
              // ScaffoldMessenger & SnackBar: menampilkan notifikasi singkat di bawah layar
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checkout berhasil, terima kasih! 🐾'),
                ),
              );
            }
                : null,
            // Container: tombol "Checkout"
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: adaItem ? warnaUtama : warnaNonaktif,
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
          ),
        ],
      ),
    );
  }
}