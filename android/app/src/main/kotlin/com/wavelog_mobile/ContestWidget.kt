package com.wavelog_mobile

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class ContestWidget : HomeWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.contest_widget)

            val dates = listOf(
                widgetData.getString("contest_date_0", null),
                widgetData.getString("contest_date_1", null),
                widgetData.getString("contest_date_2", null),
            )
            val titles = listOf(
                widgetData.getString("contest_title_0", null),
                widgetData.getString("contest_title_1", null),
                widgetData.getString("contest_title_2", null),
            )

            val dateIds = listOf(R.id.contest1_date, R.id.contest2_date, R.id.contest3_date)
            val titleIds = listOf(R.id.contest1_title, R.id.contest2_title, R.id.contest3_title)
            val rowIds = listOf(R.id.row1, R.id.row2, R.id.row3)

            if (titles[0] == null) {
                // No data yet — show placeholder
                views.setTextViewText(R.id.contest1_title, "Open Wavelog to load contests")
                views.setTextViewText(R.id.contest1_date, "")
                views.setTextViewText(R.id.contest2_title, "")
                views.setTextViewText(R.id.contest2_date, "")
                views.setTextViewText(R.id.contest3_title, "")
                views.setTextViewText(R.id.contest3_date, "")
            } else {
                for (i in 0..2) {
                    val title = titles[i] ?: ""
                    val date = dates[i] ?: ""
                    views.setTextViewText(titleIds[i], title)
                    views.setTextViewText(dateIds[i], date)
                    views.setViewVisibility(
                        rowIds[i],
                        if (title.isEmpty()) android.view.View.GONE else android.view.View.VISIBLE
                    )
                }
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
