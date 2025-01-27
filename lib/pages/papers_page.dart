import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/paper_provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PapersPage extends StatefulWidget {
  const PapersPage({super.key});

  @override
  State<PapersPage> createState() => _PapersPageState();
}

class _PapersPageState extends State<PapersPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PaperProvider>().loadPapers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 左侧论文列表
        Expanded(
          flex: 2,
          child: Card(
            child: Column(
              children: [
                // 工具栏
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: SearchBar(
                          leading: const Icon(CupertinoIcons.search),
                          hintText: '搜索论文...',
                          onChanged: (value) {
                            context.read<PaperProvider>().searchPapers(value);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(CupertinoIcons.add),
                        onPressed: () {
                          context.read<PaperProvider>().importPaper();
                        },
                      ),
                    ],
                  ),
                ),
                // 论文列表
                Expanded(
                  child: Consumer<PaperProvider>(
                    builder: (context, provider, child) {
                      return ListView.builder(
                        itemCount: provider.papers.length,
                        itemBuilder: (context, index) {
                          final paper = provider.papers[index];
                          return ListTile(
                            leading: const Icon(CupertinoIcons.doc_text),
                            title: Text(paper.title),
                            subtitle: Text(
                              '${paper.authors ?? "未知作者"} • ${paper.publishDate?.year ?? "未知年份"}'),
                            trailing: const Icon(CupertinoIcons.chevron_right),
                            selected: provider.selectedPaper?.id == paper.id,
                            onTap: () => provider.selectPaper(paper),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // 右侧预览区
        Expanded(
          flex: 3,
          child: Card(
            child: Consumer<PaperProvider>(
              builder: (context, provider, child) {
                final paper = provider.selectedPaper;
                if (paper == null) {
                  return const Center(
                    child: Text('选择一篇论文以预览'),
                  );
                }
                return Column(
                  children: [
                    // 论文详情头部
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(paper.title,
                              style: Theme.of(context).textTheme.headlineSmall),
                          const SizedBox(height: 8),
                          Text(paper.authors ?? '未知作者',
                              style: Theme.of(context).textTheme.titleMedium),
                          if (paper.publishDate != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              '发布日期: ${paper.publishDate!.year}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const Divider(),
                    // 论文摘要
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('摘要',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(paper.abstract ?? '暂无摘要'),
                            if (paper.notes != null) ...[
                              const SizedBox(height: 16),
                              Text('笔记',
                                  style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              MarkdownBody(data: paper.notes!),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
} 