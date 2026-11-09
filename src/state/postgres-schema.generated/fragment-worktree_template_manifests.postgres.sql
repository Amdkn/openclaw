-- Generated runtime DDL; the owner supplies search_path and the transaction.

CREATE TABLE "worktree_template_manifests" (
  "template_id" text COLLATE "C" NOT NULL,
  "policy_key" text COLLATE "C" NOT NULL,
  "manifest_ref" text COLLATE "C" NOT NULL,
  "manifest_zstd" bytea NOT NULL,
  PRIMARY KEY ("template_id")
);

ALTER TABLE "worktree_template_manifests" ADD FOREIGN KEY ("template_id") REFERENCES "worktree_templates" ("id") ON UPDATE NO ACTION ON DELETE CASCADE NOT DEFERRABLE;
