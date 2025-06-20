// 本地服务端口，后续可通过某种方式动态获取
let localServicePort = 16809;



// 尝试连接本地服务获取端口号
async function getConnect() {
    try {
        const response = await fetch('http://localhost:16809/connect');
        if (!response.ok) {
            throw new Error("连接失败" + response.statusText);
        }
        console.log('链接成功');
    } catch (error) {
        console.error('连接失败:', error);
        setTimeout(getConnect, 5000); // 5 秒后重试
    }
}

// 监听下载事件
chrome.downloads.onCreated.addListener(async (req) => {
    try {
        const response = await fetch(`http://localhost:16809/download`, {
            method: "POST",
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                url: req.url,
            },
            )
        });
        if (response.ok) {
            // 取消浏览器默认下载
            chrome.downloads.cancel(req.id);
            console.log("已发送下载",req.url);
            
        } else {
            console.error('本地服务返回错误状态:', response.status);
        }
    } catch (error) {
        console.error('发送下载请求到本地服务失败:', error);
    }
});

// 启动时获取本地服务端口
getConnect();