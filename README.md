# My Allergen App

> **TÜBİTAK 2209-A Üniversite Öğrencileri Araştırma Projeleri Destekleme Programı** kapsamında geliştirilmiştir.

---

## Proje Hakkında

My Allergen App, kullanıcılara ilaç saatlerini **bildirimlerle hatırlatan** bir mobil uygulamadır.

**Özgün yanımız:** Hastanın alerjisi olduğu etken maddeler profilde tutulur. Yeni bir ilaç eklendiğinde ilacın içeriğindeki maddeler bu alerjenlerle karşılaştırılır. **Eşleşme varsa kullanıcı uyarılır** ve ilacı kullanmaması gerektiği bildirilir.

**Temel özellikler**
- İlaç ekleme, kullanım sıklığı ve saat ayarı
- Bildirimlerle ilaç hatırlatma
- Alerjen profili ve ilaç–alerjen eşleşme uyarısı
- İlaç kutusundaki QR kodu / barkodu kamerayla okutma
- Kayıt olma ve giriş yapma

---

## Kullanılan Teknolojiler

| Katman | Teknoloji |
|---|---|
| Mobil | Flutter (Dart) |
| Backend | Java 21, Spring Boot 4, Spring Data JPA, Lombok |
| Veritabanı | Microsoft SQL Server |
| Derleme | Maven (backend), Gradle (Android) |

---

## Kurulum ve Çalıştırma

### 1. Gereksinimler

- [Git](https://git-scm.com/)
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (Dart 3.9 veya üzeri)
- [JDK 21](https://adoptium.net/)
- [SQL Server Express](https://www.microsoft.com/tr-tr/sql-server/sql-server-downloads) ve [SSMS](https://learn.microsoft.com/sql/ssms/download-sql-server-management-studio-ssms)
- [Android Studio](https://developer.android.com/studio) (Android emülatörü için)

Kurulumu kontrol etmek için:

```bash
flutter doctor
java -version
```

### 2. Projeyi indirin

```bash
git clone https://github.com/ikbalgokce/my_allergen_app.git
cd my_allergen_app
```

### 3. Veritabanını hazırlayın

SSMS'te yeni bir sorgu penceresi açıp aşağıdakini çalıştırın:

```sql
CREATE DATABASE my_allergen_db;
GO
CREATE LOGIN myallergen_user WITH PASSWORD = '123', CHECK_POLICY = OFF;
GO
USE my_allergen_db;
CREATE USER myallergen_user FOR LOGIN myallergen_user;
ALTER ROLE db_owner ADD MEMBER myallergen_user;
GO
```

> SQL Server'da **SQL Server Authentication** (karma mod) ve **TCP/IP (1433 portu)** açık olmalıdır. Tablolar, backend ilk kez çalıştığında otomatik oluşturulur.

### 4. Backend bağlantısını ayarlayın

`backend/src/main/resources/application.properties` dosyasındaki sunucu adını kendi bilgisayarınızınkiyle değiştirin:

```properties
spring.datasource.url=jdbc:sqlserver://BILGISAYAR_ADINIZ\\SQLEXPRESS:1433;databaseName=my_allergen_db;encrypt=true;trustServerCertificate=true
```

Bilgisayar adınızı öğrenmek için:

```bash
hostname
```

### 5. Backend'i çalıştırın

```bash
cd backend
./mvnw spring-boot:run
```

> Windows CMD kullanıyorsanız: `mvnw spring-boot:run`

Backend `http://localhost:8080` adresinde çalışır. Bu terminali açık bırakın.

### 6. Mobil uygulamayı çalıştırın

Yeni bir terminal açın, proje ana klasörüne dönün ve Android emülatörünü başlattıktan sonra:

```bash
flutter pub get
flutter run
```

> Uygulama emülatörde backend'e `http://10.0.2.2:8080` adresiyle bağlanır. **Gerçek telefonda** çalıştıracaksanız `lib/services/` altındaki dosyalarda bulunan `_baseUrl` değerini bilgisayarınızın yerel IP adresiyle değiştirin (örn. `http://192.168.1.20:8080`).

---

## Proje Yapısı

```
my_allergen_app/
├── lib/        # Flutter uygulaması (ekranlar, servisler, modeller)
├── android/    # Android yapılandırması
└── backend/    # Spring Boot REST API
```
