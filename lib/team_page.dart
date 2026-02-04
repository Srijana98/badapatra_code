import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';


class TeamCarousel extends StatefulWidget {
  final List<dynamic> teams;
  final Map<String, dynamic> orgInfo;

  const TeamCarousel({
    super.key,
    required this.teams,
    required this.orgInfo,
  });

  @override
  State<TeamCarousel> createState() => _TeamCarouselState();
}


class _TeamCarouselState extends State<TeamCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
      
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: double.infinity, // ✅ ADD THIS
              viewportFraction: 1.0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              scrollDirection: Axis.vertical,
              enlargeCenterPage: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: widget.teams.map((team) {
              return Builder(
                builder: (BuildContext context) {
                  return TeamPageCard(  // ✅ REMOVE SizedBox.expand
                    team: team,
                    orgInfo: widget.orgInfo,
                  );
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
       
      ],
    );
  }
}



class TeamPageCard extends StatelessWidget {
  final Map<String, dynamic> team;
  final Map<String, dynamic> orgInfo;

  const TeamPageCard({
    super.key,
    required this.team,
    required this.orgInfo,
  });
  
  @override
  Widget build(BuildContext context) {
    final String name = team['name'] ?? 'N/A';
    final String designation = team['designation'] ?? '';
    final String phone = team['phone'] ?? '';
    final String? attachment =
        team['attachment'] != null && team['attachment'].toString().isNotEmpty
            ? team['attachment'].toString()
            : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
        color: Colors.white,
      ),
      child: SingleChildScrollView(  // ✅ This makes it scrollable
        physics: const BouncingScrollPhysics(), // ✅ ADD smooth scrolling
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // ✅ ADD THIS
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                orgInfo['logo'] != null && orgInfo['logo'].toString().isNotEmpty
                    ? Image.network(
                        orgInfo['logo'],
                        height: 35,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/logonepal.jpg',
                            height: 35,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/logonepal.jpg',
                        height: 40,
                      ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        orgInfo['orgname_np'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        orgInfo['orgname'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        orgInfo['orgaddress1'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Image.asset(
                  'assets/flag1.gif',
                  height: 35,
                ),
              ],
            ),
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                radius: 33,
                backgroundImage: attachment != null
                    ? NetworkImage(attachment)
                    : const AssetImage('assets/images/profile.jpeg')
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              designation,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),
            Text(
              'फोन नं. : $phone',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}