import 'package:flutter/material.dart';
import '../models/notification_item.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String selectedFilter = 'Tümü'; // Tümü, İlaç, Alerji, Sistem

  final List<NotificationItem> allNotifications = [
    NotificationItem(
      id: 1,
      type: 'alerji',
      title: 'Alerji Uyarısı!',
      message: 'Eklediğiniz "Aspirin 100mg" ilacı alerjen profilinizle uyumsuz. Lütfen kontrol edin.',
      time: '5 dk önce',
      isRead: false,
      priority: 'high',
    ),
    NotificationItem(
      id: 2,
      type: 'ilac',
      title: 'İlaç Hatırlatması',
      message: 'Parol 500mg almanız gereken saat yaklaşıyor. 15 dakika kaldı.',
      time: '15 dk önce',
      isRead: false,
      priority: 'medium',
    ),
    NotificationItem(
      id: 3,
      type: 'ilac',
      title: 'İlaç Alındı',
      message: 'Vitamin D kapsülünüzü aldığınızı kaydettiniz.',
      time: '2 saat önce',
      isRead: true,
      priority: 'low',
    ),
    NotificationItem(
      id: 4,
      type: 'sistem',
      title: 'Haftalık Özet',
      message: 'Bu hafta %85 uyum oranına ulaştınız. Harika gidiyorsunuz!',
      time: '1 gün önce',
      isRead: true,
      priority: 'low',
    ),
    NotificationItem(
      id: 5,
      type: 'alerji',
      title: 'Alerjen Güncelleme',
      message: 'Alerjen profilinize "Penisilin" eklendi. Sistem tarafından kontrol ediliyor.',
      time: '2 gün önce',
      isRead: true,
      priority: 'medium',
    ),
    NotificationItem(
      id: 6,
      type: 'ilac',
      title: 'Kaçırılan İlaç',
      message: 'Aspirin 100mg dozunu kaçırdınız. Lütfen doktorunuza danışın.',
      time: '3 gün önce',
      isRead: true,
      priority: 'high',
    ),
  ];

  List<NotificationItem> get filteredNotifications {
    if (selectedFilter == 'Tümü') return allNotifications;
    
    String filterType = selectedFilter == 'İlaç' ? 'ilac' 
                      : selectedFilter == 'Alerji' ? 'alerji'
                      : 'sistem';
    
    return allNotifications.where((n) => n.type == filterType).toList();
  }

  int get unreadCount => allNotifications.where((n) => !n.isRead).length;

  void _markAsRead(int id) {
    setState(() {
      allNotifications.firstWhere((n) => n.id == id).isRead = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in allNotifications) {
        notification.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tüm bildirimler okundu olarak işaretlendi'),
        backgroundColor: Colors.green.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _deleteNotification(int id) {
    setState(() {
      allNotifications.removeWhere((n) => n.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE5E5),
            Color(0xFFFFE8CC),
            Color(0xFFFFF4E0),
            Color(0xFFE8F8F5),
          ],
          stops: [0.0, 0.35, 0.65, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bildirimler',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$unreadCount okunmamış bildirim',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                      if (unreadCount > 0)
                        InkWell(
                          onTap: _markAllAsRead,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade500, Colors.purple.shade600],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'Tümü Okundu',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Filter Tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['Tümü', 'İlaç', 'Alerji', 'Sistem'].map((filter) {
                        bool isSelected = selectedFilter == filter;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedFilter = filter;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                gradient: isSelected
                                    ? LinearGradient(
                                        colors: [Colors.blue.shade500, Colors.purple.shade600],
                                      )
                                    : null,
                                color: isSelected ? null : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                filter,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey.shade700,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Notifications List
            Expanded(
              child: filteredNotifications.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.notifications_off_outlined,
                            size: 80,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Bildirim Yok',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Henüz bildiriminiz bulunmuyor',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredNotifications.length,
                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];
                        return _buildNotificationCard(notification);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    Color getTypeColor() {
      switch (notification.type) {
        case 'alerji':
          return Colors.red.shade500;
        case 'ilac':
          return Colors.blue.shade500;
        case 'sistem':
          return Colors.purple.shade500;
        default:
          return Colors.grey.shade500;
      }
    }

    IconData getTypeIcon() {
      switch (notification.type) {
        case 'alerji':
          return Icons.warning_amber_rounded;
        case 'ilac':
          return Icons.medication;
        case 'sistem':
          return Icons.info;
        default:
          return Icons.notifications;
      }
    }

    return Dismissible(
      key: Key(notification.id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        _deleteNotification(notification.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Bildirim silindi'),
            action: SnackBarAction(
              label: 'Geri Al',
              onPressed: () {
                setState(() {
                  // Geri alma işlemi
                });
              },
            ),
          ),
        );
      },
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.shade400,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            _markAsRead(notification.id);
          }
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: notification.isRead ? Colors.white : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(16),
            border: notification.isRead 
                ? null 
                : Border.all(color: Colors.blue.shade200, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: getTypeColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    getTypeIcon(),
                    color: getTypeColor(),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade600,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            notification.time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                          if (notification.priority == 'high')
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Acil',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.red.shade700,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}