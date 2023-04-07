#!/bin/bash

source ./config.sh

$OUT_DB_PSQL << _EOF_

\echo ... building files namespace:name index ...
create unique index files_names on files(namespace, name);
create index files_name on files(name);
create index files_size on files(size);

\echo ... indexing file attributes ...
create index files_creator on files(creator);
create index files_created_timestamp on files(created_timestamp);
create index files_size on files(size);

\echo ... building other indexes ...
create index parent_child_child on parent_child(child_id);
alter table files_datasets add primary key (dataset_namespace, dataset_name, file_id);
create index files_datasets_file_id on files_datasets(file_id);
create index datasets_meta_index on datasets using gin (metadata jsonb_path_ops);

_EOF_
