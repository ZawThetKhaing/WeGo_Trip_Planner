import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:we_go/controller/trip_plan_controller.dart';
import 'package:we_go/global.dart';
import 'package:we_go/model/trip_plan_model.dart';
import 'package:we_go/routes/routes.dart';
import 'package:we_go/theme/appTheme.dart';
import 'package:we_go/widgets/add_plan_bottom_sheet.dart';
import 'package:we_go/widgets/budget_view.dart';
import 'package:we_go/widgets/people_listTile.dart';
import 'package:flutter/material.dart';
import 'package:we_go/widgets/plan_list_view.dart';

class TripPlanTabBarView extends StatefulWidget {
  // final Stream<TripPlanModel> stream;
  final TripPlanModel model;
  const TripPlanTabBarView({
    // required this.stream,
    required this.model,
    super.key,
  });

  @override
  State<TripPlanTabBarView> createState() => _TripPlanTabBarViewState();
}

class _TripPlanTabBarViewState extends State<TripPlanTabBarView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);

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
                  model: widget.model,
                  // stream: widget.stream,
                ),
                _PeopleView(
                  model: widget.model,
                ),
                _BudgetView(
                  model: widget.model,

                  // stream: widget.stream,
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
  final TripPlanModel model;
  const _TripPlanView({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    int dateRange = DateTimeRange(
      start: DateTime.parse(model.startDate),
      end: DateTime.parse(model.endDate),
    ).duration.inDays;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        itemCount: dateRange,
        itemBuilder: (_, index) {
          final List<PlanDays> checkedPlans = model.plans ?? [];

          return Column(
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
              checkedPlans.indexWhere(
                        (element) => element.day == (index + 1).toString(),
                      ) ==
                      -1
                  ? const SizedBox()
                  : PlanListView(
                      model: model,
                      plans: checkedPlans[checkedPlans.indexWhere(
                        (element) => element.day == (index + 1).toString(),
                      )]
                          .plans,
                    ),

              ///Add plan
              GestureDetector(
                onTap: () {
                  Get.find<TripPlanController>().days.value = index + 1;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => AddPlanBottomSheet(
                      dateRange: dateRange,
                      model: model,
                    ),
                  );
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
          );
        },
      ),
    );
  }
}

class _PeopleView extends StatelessWidget {
  final TripPlanModel model;
  const _PeopleView({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final TripPlanController _tripPlanController =
        Get.find<TripPlanController>();
    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Trip members",
                style: AppTheme.welcomeTextStyle.copyWith(
                  color: AppTheme.textColor1,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PeopleListTile(
              name: model.owner.userName ?? '',
              status: "Trip Creator",
              photoLink: model.owner.profilePhoto,
            ),
            if (model.participants?.isEmpty == true) ...[
              const SizedBox()
            ] else ...[
              Column(
                children: List.generate(
                  model.participants?.length ?? 0,
                  (i) => PeopleListTile(
                    name: model.participants?[i].userName ?? '',
                    status: "Add by ${model.participants?[i].addBy}",
                    photoLink: model.participants?[i].profilePhoto,
                    isCreator:
                        model.owner.uid == authService.auth.currentUser?.uid,
                    remove: () {
                      _tripPlanController.removeFriend(
                          model, model.participants?[i].uid ?? '');
                    },
                  ),
                ),
              ),
            ],
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.inviteFriend, arguments: model);
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
        ),
      ],
    );
  }
}

class _BudgetView extends StatelessWidget {
  final TripPlanModel model;

  const _BudgetView({
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    model.participants?.sort(
      (a, b) => a.createdAt!.compareTo(b.createdAt!),
    );
    final List<int> allBudget = [
      model.owner.budgetPaid ?? 0,
    ];

    allBudget.addAll(
      List.generate(
        model.participants?.length ?? 0,
        (index) => model.participants?[index].budgetPaid ?? 0,
      ),
    );

    int totalBudget =
        allBudget.fold(0, (previousValue, element) => previousValue + element);

    return ListView(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
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
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                BudgetPaidList(
                  userModel: model.owner,
                  tripPlanModel: model,
                  isTripCreater: false,
                ),
                if (model.participants?.isEmpty == true) ...[
                  const SizedBox(),
                ] else ...[
                  Column(
                    children: List.generate(
                      model.participants?.length ?? 0,
                      (i) => BudgetPaidList(
                        userModel: model.participants![i],
                        tripPlanModel: model,
                        isTripCreater: model.owner.uid ==
                            authService.auth.currentUser!.uid,
                      ),
                    ),
                  ),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18.0),
                  child: Row(
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
                        "$totalBudget MMK",
                        style: AppTheme.welcomeTextStyle.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
