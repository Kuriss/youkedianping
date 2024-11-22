-- 1.参数列表
-- 1.1优惠券id
local voucherId = ARGV[1]
-- 1.2用户id
local userId = ARGV[2]
-- 1.3订单id
local orderId = ARGV[3]

-- 2.数据key
-- 2.1.库存key
local stockKey = 'seckill:stock:' .. voucherId
-- 2.2.订单key
local orderKey = 'seckill:order:' .. voucherId

-- 3.脚本业务
-- 3.1.

local stock = redis.call('GET', stockKey);
if (tonumber(stock) <= 0) then
    -- 库存不足，返回1
    return 1;
end

if(redis.call('sismember',orderKey,userId)==1) then
    return 2
end

redis.call('incrby',stockKey,-1)

redis.call('sadd',orderKey,userId)

redis.call('xadd','stream.orders','*','userId',userId,'voucherId',voucherId,'id',orderId)
return 0