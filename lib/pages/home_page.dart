import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/paper_provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Row(
        children: [
          // 左侧文件夹列表
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(right: BorderSide(color: Colors.grey[300]!)),
            ),
            child: ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('我的文库'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Arxiv论文'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('会议论文'),
                  onTap: () {},
                ),
                // 更多文件夹...
              ],
            ),
          ),
          // 中间论文列表
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // 工具栏
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: '搜索论文...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          onChanged: (value) {
                            context.read<PaperProvider>().searchPapers(value);
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          // TODO: 添加论文
                        },
                      ),
                    ],
                  ),
                ),
                // 论文列表表头
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
                  ),
                  child: const Row(
                    children: [
                      Expanded(flex: 3, child: Text('标题')),
                      Expanded(child: Text('年份')),
                      Expanded(flex: 2, child: Text('来源')),
                    ],
                  ),
                ),
                // 论文列表
                Expanded(
                  child: Consumer<PaperProvider>(
                    builder: (context, provider, child) {
                      final papers = provider.papers;
                      if (papers.isEmpty) {
                        return const Center(
                          child: Text('暂无论文'),
                        );
                      }
                      return ListView.builder(
                        itemCount: papers.length,
                        itemBuilder: (context, index) {
                          final paper = papers[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
                            ),
                            child: ListTile(
                              title: Text(paper.title),
                              subtitle: Text(paper.authors ?? '未知作者'),
                              trailing: Text(paper.publishDate?.year.toString() ?? '未知'),
                              onTap: () {
                                // TODO: 选中论文
                              },
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          // 右侧预览区域
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                border: Border(left: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Center(
                child: Text(
                  '选择一篇论文以预览',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 