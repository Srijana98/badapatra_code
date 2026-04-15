
// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cached_network_image/cached_network_image.dart';


// class TeamCarousel extends StatefulWidget {
//   final List<dynamic> teams;
//   final Map<String, dynamic> orgInfo;


//   const TeamCarousel({
//     super.key,
//     required this.teams,
//     required this.orgInfo,
//   });

//   @override
//   State<TeamCarousel> createState() => _TeamCarouselState();
  
// }

// class _TeamCarouselState extends State<TeamCarousel> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Expanded(
//           child: CarouselSlider(
//             options: CarouselOptions(
//               height: double.infinity, 
//               viewportFraction: 1.0,
//               autoPlay: true,
//               autoPlayInterval: const Duration(seconds: 4),
//               autoPlayAnimationDuration: const Duration(milliseconds: 800),
//               autoPlayCurve: Curves.fastOutSlowIn,
//               enableInfiniteScroll: true,
//               scrollDirection: Axis.vertical,
//               enlargeCenterPage: false,
//               onPageChanged: (index, reason) {
//                 setState(() {
//                   _currentIndex = index;
//                 });
//               },
//             ),
//             items: widget.teams.map((team) {
//               return Builder(
//                 builder: (BuildContext context) {
//                   return TeamPageCard(  
//                     team: team,
//                     orgInfo: widget.orgInfo,
//                   );
//                 },
//               );
//             }).toList(),
//           ),
//         ),
//       ],
//     );
//   }
// }



// class TeamPageCard extends StatelessWidget {
//   final Map<String, dynamic> team;
//   final Map<String, dynamic> orgInfo;

//   const TeamPageCard({
//     super.key,
//     required this.team,
//     required this.orgInfo,
//   });
  
//   @override
//   Widget build(BuildContext context) {
//     final String name = team['name'] ?? 'N/A';
//     final String designation = team['designation'] ?? '';
//     final String phone = team['phone'] ?? '';
//     final String? attachment =
//         team['attachment'] != null && team['attachment'].toString().isNotEmpty
//             ? team['attachment'].toString()
//             : null;

//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       padding: const EdgeInsets.all(8),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.red, width: 2),
//       ),
//       child: SingleChildScrollView(   
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         //mainAxisSize: MainAxisSize.max,
//         mainAxisSize: MainAxisSize.min, 
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               orgInfo['logo'] != null && orgInfo['logo'].toString().isNotEmpty
//                   ? Image.network(
//                       orgInfo['logo'],
//                       height: 35,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Image.asset(
//                           'assets/logonepal.jpg',
//                           height: 35,
//                         );
//                       },
//                     )
//                   : Image.asset(
//                       'assets/logonepal.jpg',
//                       height: 40,
//                     ),
//               const SizedBox(width: 6),
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Text(
//                       orgInfo['header_text1'] ?? '',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Color(0xFFcd0711),
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       orgInfo['header_text2'] ?? '',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Color(0xFFcd0711),
//                         fontSize: 13,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       orgInfo['header_text3'] ?? '',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Color(0xFF2056ae),
//                         fontSize: 11,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Image.asset(
//                 'assets/flag1.gif',
//                 height: 35,
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           CircleAvatar(
//            // radius: 35,
//             radius: 50,
//             backgroundColor: Colors.blue,
//             child: CircleAvatar(
//              // radius: 33,
//               radius: 47, 
//               backgroundImage: attachment != null
//                   ? NetworkImage(attachment)
//                   : const AssetImage('assets/images/profile.jpeg')
//                       as ImageProvider,
//             ),
//           ),
//           const SizedBox(height: 6),
//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//               vertical: 5,
//             ),
//             decoration: BoxDecoration(
//               color: Colors.blue,
//               borderRadius: BorderRadius.circular(30),
//             ),
//             child: Text(
//               name,
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 13,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           const SizedBox(height: 5),
//           Text(
//             designation,
//             style: const TextStyle(
//               color: Colors.red,
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//             ),
//             textAlign: TextAlign.center,
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const SizedBox(height: 5),
//           Text(
//             'फोन नं. : $phone',
//             style: const TextStyle(
//               color: Colors.blue,
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Slider चल्नु अघि नै सबै टिम मेम्बरको फोटो Background मा लोड गराउने (Precache)
    for (var team in widget.teams) {
      final String? attachment = team['attachment']?.toString();
      if (attachment != null && attachment.isNotEmpty) {
        precacheImage(CachedNetworkImageProvider(attachment), context);
      }
    }
    
    // संस्थाको Logo लाई पनि Precache गर्ने
    final String? logo = widget.orgInfo['logo']?.toString();
    if (logo != null && logo.isNotEmpty) {
      precacheImage(CachedNetworkImageProvider(logo), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: CarouselSlider(
            options: CarouselOptions(
              height: double.infinity, 
              viewportFraction: 1.0,
              autoPlay: true,
            //  autoPlayInterval: const Duration(seconds: 4),
            // code to make the fast loading of the photo
              autoPlayInterval: const Duration(seconds: 6), 
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
                  return TeamPageCard(  
                    team: team,
                    orgInfo: widget.orgInfo,
                  );
                },
              );
            }).toList(),
          ),
        ),
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
      height: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red, width: 2),
      ),
      child: SingleChildScrollView(   
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, 
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              orgInfo['logo'] != null && orgInfo['logo'].toString().isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: orgInfo['logo'],
                      height: 35,
                      fit: BoxFit.contain,
                      errorWidget: (context, url, error) {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      orgInfo['header_text1'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFcd0711),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   // const SizedBox(height: 2),
                    Text(
                      orgInfo['header_text2'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFcd0711),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //const SizedBox(height: 2),
                    Text(
                      orgInfo['header_text3'] ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFF2056ae),
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
        //  const SizedBox(height: 8),
        const SizedBox(height: 3),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              radius: 47, 
              // NetworkImage को सट्टा CachedNetworkImageProvider प्रयोग गरिएको
              backgroundImage: attachment != null
                  ? CachedNetworkImageProvider(attachment)
                  : const AssetImage('assets/images/profile.jpeg')
                      as ImageProvider,
            ),
          ),
        //  const SizedBox(height: 6),
        const SizedBox(height: 3),
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
        //  const SizedBox(height: 5),
        const SizedBox(height: 1),
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
         // const SizedBox(height: 5),
         const SizedBox(height: 1),

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