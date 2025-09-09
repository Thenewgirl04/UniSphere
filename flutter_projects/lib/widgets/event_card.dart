import 'package:flutter/material.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String date;
  final String time;
  final String org;
  final String imageAsset;
  final double cardWidth;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.org,
    required this.imageAsset,
    required this.cardWidth,
    this.onTap,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}
class _EventCardState extends State<EventCard> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.onTap,
        child:Container(
      width: widget.cardWidth,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              widget.imageAsset,
              width: double.infinity,
              height: 120,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.broken_image, size: 40),
            ),
          ),
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment:  MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child:
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis, maxLines: 1,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: toggleLike,
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : Colors.grey,
                size: 20,
              ),
            ),
          ],
          ),
          const SizedBox(height: 8),
          Text(widget.org, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(widget.date),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(widget.time),
            ],
          ),

        ],
        ),
      ),
    );
  }
}