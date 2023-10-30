import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/budget_view.dart';

class TripPlanTabBarView extends StatefulWidget {
  final TripPlanModel model;
  const TripPlanTabBarView({
    super.key,
    required this.model,
  });

  @override
  State<TripPlanTabBarView> createState() => _TripPlanTabBarViewState();
}

class _TripPlanTabBarViewState extends State<TripPlanTabBarView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  int dateRange = 0;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    dateRange = DateTimeRange(
      start: DateTime.parse(widget.model.startDate),
      end: DateTime.parse(widget.model.endDate),
    ).duration.inDays;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, left: 15, right: 15),
      child: Column(
        children: [
          TabBar(
            labelPadding: const EdgeInsets.only(bottom: 12),
            indicatorColor: AppTheme.brandColor,
            labelStyle: AppTheme.normalTextStyle.copyWith(
              fontWeight: FontWeight.w600,
            ),
            labelColor: Colors.black,
            unselectedLabelStyle: AppTheme.normalTextStyle.copyWith(
              color: Colors.black,
            ),
            controller: _tabController,
            tabs: const [
              Text("Trip plan"),
              Text("People"),
              Text("Budget"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _TripPlanView(
                  dateRange: dateRange,
                ),
                _PeopleView(
                  model: widget.model,
                ),
                _BudgetView(
                  model: widget.model,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TripPlanView extends StatelessWidget {
  final int dateRange;
  const _TripPlanView({
    super.key,
    required this.dateRange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: ListView(
        children: List.generate(
          dateRange,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Day ${index + 1}",
                style: AppTheme.normalTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const Icon(
                      Icons.add_circle,
                      size: 13,
                      color: AppTheme.brandColor,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Add plan",
                      style: AppTheme.welcomeTextStyle.copyWith(
                        color: AppTheme.brandColor,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeopleView extends StatelessWidget {
  final TripPlanModel model;
  const _PeopleView({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Text(
                "Trip members",
                style: AppTheme.welcomeTextStyle.copyWith(
                  color: AppTheme.textColor1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 17,
                ),
                const SizedBox(
                  width: 5,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.owner,
                      style: AppTheme.welcomeTextStyle.copyWith(
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      "Trip Creator",
                      style: AppTheme.welcomeTextStyle.copyWith(
                        fontSize: 10,
                        color: AppTheme.tripPlanTextColor,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.inviteFriend);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.add_circle,
                    size: 13,
                    color: AppTheme.brandColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Invite friends",
                    style: AppTheme.bottomNavTextStyle.copyWith(
                      color: AppTheme.tripPlanTextColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}

class _BudgetView extends StatelessWidget {
  final TripPlanModel model;
  const _BudgetView({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Text(
                "${NumberFormat.currency(
                  locale: Localizations.localeOf(context).toString(),
                ).format(model.budget).substring(
                      3,
                    ).split('.').first} MMK per person",
                style: AppTheme.welcomeTextStyle.copyWith(
                  color: AppTheme.textColor1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Text(
              "Payment due date : ${DateFormat.yMMMd().format(
                DateTime.parse(
                  model.paymentDueDate,
                ),
              )}",
              style: AppTheme.bottomNavTextStyle.copyWith(
                color: AppTheme.tripPlanTextColor,
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                itemCount: 1,
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      BudgetPaidList(name: model.owner),
                      const BudgetPaidList(name: "ZTK"),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: AppTheme.welcomeTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            "440,000 MMK",
                            style: AppTheme.welcomeTextStyle.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(AppRoutes.inviteFriend);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.add_circle,
                              size: 13,
                              color: AppTheme.brandColor,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Invite friends",
                              style: AppTheme.bottomNavTextStyle.copyWith(
                                color: AppTheme.tripPlanTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
