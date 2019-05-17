local width,height=getScreenSize()

local dev='mi'

if(width==720 and height==1280) then
    dev='mi'
end

local cood={
    ["mi"]={
        nav_msg={x=71,y=1224}
    }
}

function click(x, y)
    touchDown(x, y)
    mSleep(30)
    touchUp(x, y)
end

function notify()
    for var = 1, 3 do
        vibrator();
        mSleep(500);
    end
end

function shake()
    types = getDeviceType();
    if types ~= 3 and types ~= 4 then
        shakeDevice(0, 0, -3, 3000);
        mSleep(3000);
    end
end

function unlock()
    flag = deviceIsLock();
    if flag ~= 0 then
        unlockDevice();
        mSleep(1000);
    end
end

function vSlide(x, y1, y2)
    for var = 1, 3 do
        touchDown(x, y1);
        mSleep(30);
        touchMove(x, y2);
        mSleep(30);
        touchUp(x, y2);
        mSleep(500)
    end
end

function vSlideUp(...)
    local x=width/2
    local y1=height/2
    local y2=y1-100

    touchDown(x, y1);
    mSleep(30);
    touchMove(x, y2);
    mSleep(30);
    touchUp(x, y2);
    mSleep(500)
end

function vSlideDown(...)
    local width,height=getScreenSize()

    local x=width/2
    local y1=height/2
    local y2=y1+100

    touchDown(x, y1);
    mSleep(30);
    touchMove(x, y2);
    mSleep(30);
    touchUp(x, y2);
    mSleep(500)
end

-- 点击湖南民乐工作通知
function clickNotifyHNML()
    local width,height=getScreenSize()
    local ok=false
    for i=1,300 do
        x,y = findMultiColorInRegionFuzzy( 0x88c2fc, "1|-25|0x3296fa,2|-38|0xffffff,16|-37|0x6db4fb,12|0|0x3598fa,12|11|0x8dc4fc", 90, 4, 1167, width-1, height-1)
        -- 确保导航栏【消息】按钮是选中状态
        if(x<0) then
            local btn = cood[dev].nav_msg
            click(btn.x,btn.y)
            mSleep(3000)
        else
            ok=true
            break
        end
        mSleep(10)
    end
    if(not ok) then
        return false
    end
    ok = false
    for i=1,5 do
        x,y = findMultiColorInRegionFuzzy( 0x33aaff, "89|-29|0x34393f,115|-30|0x464b50,154|-32|0x6d7175,180|-32|0x34393f", 90, 0, 0, width-1,height-1)
        if(x>0) then
            click(x,y)
            ok=true
            mSleep(3000)
            break
        end
        vSlide(500, height, height/2);
        mSleep(2000)
    end
    return ok
end

-- clickNotifyHNML()
--vSlideDown()

function sendWechatText(text)
    require "TSLib"
    local ts = require("ts")--使用扩展库前必须插入这一句
    local json = ts.json--使用 JSON 模块前必须插入这一句

    local data = {
        ["action"]="send",
        ["params"]={
            ["type"]="text",
            ["username"]="@dcf4ae1e7cc1712f66a8246d2260c32ddff6344f81c3e7943b075b2efdc87550",
            ["content"]=text
        }
    }
    local jsonstring = json.encode(data);--把 table 转换成 json 字符串
    httpPost('http://192.168.1.109:8866',jsonstring)
end

function ocrDate(...)
    local x1,x2,y1,y2=0,0,0,0
    local month,day=0,0
    local whitelist="1234567890"
    local x,y = findMultiColorInRegionFuzzy( 0xffffff, "32|1|0xd0d1d3,32|2|0x838689,81|2|0x9ea0a3,81|3|0x8e9194,95|7|0x8c8f92,96|21|0x9d9fa2", 90, 0, height/2, width-1, height-1)
    if(x>0)then
        x1=x
        x2=x+27
        y1=y
        y2=y+22
        month = ocrText(x1, y1, x2, y2, 0,whitelist)
        x1=x+47
        x2=x+80
        day = ocrText(x1, y1, x2, y2, 0,whitelist)
    end
    return string.format('%s月%s日',month,day)
end

function ocrTime(...)
    local x1,x2,y1,y2=0,0,0,0
    local hour,minute=0,0
    local whitelist="1234567890"
    local x,y = findMultiColorInRegionFuzzy( 0xffffff, "0|1|0x8e9194,-21|1|0x838689,-30|1|0xbabcbe,-43|2|0x34393f,-48|2|0x34393f,-68|2|0x34393f,-79|2|0x8c8f92", 90,0, height/2, width-1, height-1)
    if(x>0) then
        x1=x+17
        x2=x+47
        y1=y
        y2=y+23
        hour = ocrText(x1, y1, x2, y2, 0,whitelist)
        x1=x+55
        x2=x+87
        minute = ocrText(x1, y1, x2, y2, 0,whitelist)
    end
    return string.format('%s时%s分',hour,minute)
end

shake();
unlock();
mSleep(1000);
vSlide(500, 900, 500);
mSleep(5000);

for var = 1, 3 do
    runApp('com.alibaba.android.rimet');
    setScreenScale(true, 720, 1280);
    mSleep(10000);
    click(360, 1200);
    setScreenScale(false)
    mSleep(5000)
    -- 根据像素模糊查找考勤按钮
    x, y = findMultiColorInRegionFuzzy(0x4da9eb, "0|6|0xffffff,6|6|0x4da9eb,6|18|0x4da9eb,6|21|0xffffff,17|21|0x4da9eb,15|10|0xe0f0fb,15|-1|0xcde6f9,15|-12|0xdeeffb,15|-18|0x4da9eb", 90, 0, 0, 719, 1279);
    if x ~= -1 and y ~= -1 then
        click(x, y);
    else
        click(93, 976);
    end
    mSleep(20000);

    x1, y1 = findMultiColorInRegionFuzzy(0x7baaf7, "0|11|0xffffff,6|8|0x85b0f8,6|-8|0xffffff,6|-16|0x5e97f6,-3|-16|0xffffff,-10|-2|0x5e97f6,-12|10|0xffffff,-17|12|0xf6f9ff,14|12|0xf6f9ff", 90, 0, 0, 719, 1279);
    if x1 ~= -1 and y1 ~= -1 then
        click(x1, y1);
        click(x1, y1);
        click(x1, y1);
    else
        click(375, 868);
        click(375, 868);
        click(375, 868);
    end
    mSleep(10000);
    closeApp('com.alibaba.android.rimet');
    notify();
    mSleep(5000);
end