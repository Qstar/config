CREATE TABLE `user` (
  `id`        INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(11)               DEFAULT NULL,
  PRIMARY KEY (`id`)
)
  ENGINE = MyISAM
  AUTO_INCREMENT = 5
  DEFAULT CHARSET = utf8;

# user1
INSERT INTO `user1` (`id`, `user_name`, `over`)
VALUES
  (1, '唐僧', '旃檀功德佛'),
  (2, '猪八戒', '净坛使者'),
  (3, '孙悟空', '齐天大圣'),
  (4, '沙僧', '金身罗汉');

# user2
INSERT INTO `user2` (`id`, `user_name`, `over`)
VALUES
  (1, '牛魔王', '被降服'),
  (2, '蛟魔王', '被降服'),
  (3, '鹏魔王', '被降服'),
  (4, '狮驼王', '被降服'),
  (5, '孙悟空', '成佛');

CREATE TABLE `user_kills` (
  `id`      INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(11)                   DEFAULT NULL,
  `timestr` VARCHAR(50)               DEFAULT NULL,
  `kills`   INT(11)                   DEFAULT NULL,
  PRIMARY KEY (`id`)
)
  ENGINE = MyISAM
  AUTO_INCREMENT = 10
  DEFAULT CHARSET = utf8;

#user_kills
INSERT INTO `user_kills` (`id`, `user_id`, `timestr`, `kills`)
VALUES
  (1, 2, '2013-01-10 00:00:00', 10),
  (2, 2, '2013-02-01 00:00:00', 2),
  (3, 2, '2013-02-15 00:00:00', 12),
  (4, 4, '2013-01-10 00:00:00', 3),
  (5, 2, '2013-02-11 00:00:00', 5),
  (6, 2, '2013-02-06 00:00:00', 1),
  (7, 3, '2013-01-11 00:00:00', 20),
  (8, 2, '2013-02-12 00:00:00', 10),
  (9, 2, '2013-02-07 00:00:00', 17);

# Join操作的类型--Inner Join

SELECT
  a.user_name,
  a.over,
  b.over
FROM user1 a
  INNER JOIN user2 b
    ON a.user_name = b.user_name;

# Join操作的类型--Left Outer Join
SELECT
  a.user_name,
  a.over,
  b.over
FROM user1 a
  LEFT JOIN user2 b
    ON a.user_name = b.user_name
WHERE b.user_name IS NULL;

# Join操作的类型--Right Outer Join
SELECT
  b.user_name,
  b.over,
  a.over
FROM user1 a
  RIGHT JOIN user2 b
    ON a.user_name = b.user_name
WHERE a.user_name IS NOT NULL;

# Join操作的类型--Full Join
SELECT
  a.user_name,
  a.over,
  b.over
FROM user1 a
  LEFT JOIN user2 b ON a.user_name = b.user_name
UNION ALL
SELECT
  b.user_name,
  b.over,
  a.over
FROM user1 a
  RIGHT JOIN user2 b ON a.user_name = b.user_name;

# Join操作的类型--Cross Join(笛卡尔集)
SELECT
  a.user_name,
  a.over,
  b.user_name,
  b.over
FROM user1 a
  CROSS JOIN user2 b;

# 使用Join更新表
#mysql 不支持 error:1093
UPDATE user1
SET over = '齐天大圣'
WHERE user1.user_name IN (
  SELECT b.user_name
  FROM user1 a INNER JOIN user2 b ON a.user_name = b.user_name
);

UPDATE user1 a JOIN (
                      SELECT b.user_name
                      FROM user1 a INNER JOIN user2 b ON
                                                        a.user_name = b.user_name
                    ) b ON a.user_name = b.user_name
SET a.over = '齐天大圣';

# 使用join 优化子查询
# 未优化
SELECT
  a.user_name,
  a.over,
  (SELECT over
   FROM user2 b
   WHERE a.user_name = b.user_name) AS over2
FROM user1 a;

#优化后
SELECT
  a.user_name,
  a.over,
  b.over AS over2
FROM user1 a LEFT JOIN user2 b ON a.user_name = b.user_name;

# 使用Join优化聚合子查询
# 未优化
SELECT
  a.user_name,
  b.timestr,
  b.kills
FROM user1 a JOIN user_kills b
    ON a.id = b.user_id
WHERE b.kills = (SELECT max(c.kills)
                 FROM user_kills c
                 WHERE
                   c.user_id = b.user_id);

# 优化后
SELECT
  a.user_name,
  b.timestr,
  b.kills
FROM user1 a
  JOIN user_kills b ON a.id = b.user_id
  JOIN user_kills c ON c.user_id = b.user_id
GROUP BY a.user_name, b.timestr, b.kills
HAVING b.kills = max(c.kills);

# 使用Join实现分组查询
SELECT
  d.user_name,
  c.timestr,
  kills
FROM (
       SELECT
         user_id,
         timestr,
         kills,
         (SELECT count(*)
          FROM user_kills b
          WHERE
            b.user_id = a.user_id AND a.kills <= b.kills) AS cnt
       FROM user_kills a
       GROUP BY user_id, timestr, kills
     ) c JOIN user1 d ON c.user_id = d.id
WHERE cnt <= 2;
