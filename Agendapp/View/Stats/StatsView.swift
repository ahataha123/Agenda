//
//  StatsView.swift
//  Agendapp
//

import SwiftUI
import SwiftData
import Charts

struct StatsView: View {
    @AppStorage("forceDarkMode") private var forceDarkMode = false
    
    
    @Query private var todos: [Todo]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                           Label("Dark Mode", systemImage: "moon.fill")
                           Spacer()
                           Toggle("", isOn: $forceDarkMode)
                               .labelsHidden()
                       }
                       .padding()
                       .background(
                           RoundedRectangle(cornerRadius: 16)
                               .fill(.ultraThinMaterial)
                       )
                    // STAT CARDS
                    statCard(
                        title: "Due today",
                        value: dueToday,
                        systemImage: "sun.max"
                    )

                    statCard(
                        title: "Completed today",
                        value: completedToday,
                        systemImage: "checkmark.circle"
                    )

                    statCard(
                        title: "Overdue",
                        value: overdue,
                        systemImage: "exclamationmark.triangle",
                        color: .red
                    )

                    statCard(
                        title: "Upcoming",
                        value: upcoming,
                        systemImage: "calendar"
                    )

                    statCard(
                        title: "Completion rate today",
                        value: completionRate,
                        suffix: "%",
                        systemImage: "percent"
                    )

                    //  DONUT CHART
                    if !taskDistribution.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Task distribution")
                                .font(.headline)

                            Chart(taskDistribution) { slice in
                                SectorMark(
                                    angle: .value("Count", slice.value),
                                    innerRadius: .ratio(0.6)
                                )
                                .foregroundStyle(slice.color)
                                .annotation(position: .overlay) {
                                    Text("\(slice.value)")
                                        .font(.caption)
                                        .foregroundStyle(.white)
                                }
                            }
                            .frame(height: 220)

                            // Legend
                            VStack(spacing: 6) {
                                ForEach(taskDistribution) { slice in
                                    HStack {
                                        Circle()
                                            .fill(slice.color)
                                            .frame(width: 10, height: 10)

                                        Text(slice.label)
                                            .font(.caption)

                                        Spacer()

                                        Text("\(slice.value)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("Stats")
        }
    }

    // MARK: - Base sets

    private var tasksDueToday: [Todo] {
        todos.filter { $0.isDueToday }
    }

    private var completedDueToday: Int {
        tasksDueToday.filter { $0.isCompletedToday }.count
    }

    // MARK: - Computed stats

    private var dueToday: Int {
        tasksDueToday.count
    }

    private var completedToday: Int {
        todos.filter { $0.isCompletedToday }.count
    }

    private var overdue: Int {
        todos.filter { $0.isOverdue }.count
    }

    private var upcoming: Int {
        todos.filter {
            $0.dueDate > Calendar.current.startOfDay(for: Date())
            && $0.completedAt == nil
        }.count
    }

    private var completionRate: Int {
        let total = tasksDueToday.count
        guard total > 0 else { return 100 }
        return Int((Double(completedDueToday) / Double(total)) * 100)
    }

    // MARK: - Chart data

    private var taskDistribution: [TaskSlice] {
        [
            TaskSlice(
                label: "Completed",
                value: todos.filter { $0.completedAt != nil }.count,
                color: .green
            ),
            TaskSlice(
                label: "Active",
                value: todos.filter {
                    $0.completedAt == nil && !$0.isOverdue
                }.count,
                color: .blue
            ),
            TaskSlice(
                label: "Overdue",
                value: todos.filter { $0.isOverdue }.count,
                color: .red
            )
        ].filter { $0.value > 0 }
    }

    // MARK: - UI helper

    @ViewBuilder
    private func statCard(
        title: String,
        value: Int,
        suffix: String = "",
        systemImage: String,
        color: Color = .primary
    ) -> some View {
        HStack {
            Label(title, systemImage: systemImage)
                .foregroundStyle(color)

            Spacer()

            Text("\(value)\(suffix)")
                .font(.headline)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
        )
    }
}

// MARK: - Chart model

struct TaskSlice: Identifiable {
    let id = UUID()
    let label: String
    let value: Int
    let color: Color
}

